use super::model::{CreateTask, Task, UpdateTask};
use crate::app_state::AppState;
use axum::{
  extract::{Json, Path, State},
  http::StatusCode,
  response::IntoResponse,
};
use shared::errors::{ApiErrorMessage, AppError as ServerError, AppError};
use futures::future::err;
// use bb8::{PooledConnection, RunError};
// use bb8_redis::RedisConnectionManager;
// use futures::future::err;
use tracing::{debug, error, info, instrument, span, warn, Level};
use models::streams::{
  CrudActions, DeleteDto, ReadDto, Stream, StreamKeys, CREATE, DELETE, PAYLOAD, REDIS_STREAMS,
  TASKS_STREAM, UPDATE, USERS_STREAM,
};
use redis::{AsyncCommands, RedisResult};
use serde_json::Error;
use services::postgres::{
  results::{handle_delete_result, handle_drop_result, handle_result},
  service::{create_item, delete_by_id, drop_collection, get_by_id, get_list, update_by_id},
};
use uuid::Uuid;
use validator::Validate;

#[utoipa::path(
  get,
  path = "/api/task-redis-response",
  tag = "Tasks Redis response",
  responses(
(status = 200, description = "Collection found successfully", body = [Task]),
  ),
)]
pub async fn get_tasks(State(app_state): State<AppState>) -> impl IntoResponse {
  let result = get_list::<Task>(&app_state.pool, &None).await;
  handle_result(result, StatusCode::OK)
}

/// Get Task by id.
///
/// Return found `Task` with status 200 or 404 not found if `Task` is not found from Postgres DB.
#[utoipa::path(
  get,
  path = "/api/task-redis-response/{id}",
  tag = "Tasks Redis response",
  responses(
(status = 200, description = "Task found from db", body = Task),
  ),
  params(
("id", description = "Unique storage id of Task")
  )
)]
pub async fn get_task(
  Path(id): Path<String>,
  State(app_state): State<AppState>,
) -> Result<Json<Task>, AppError> {
  let request_id = Uuid::new_v4().to_string();

  let mut conn = app_state.redis.get().await?;

  Uuid::parse_str(&id)?;
  let object = ReadDto::new(id);

  let body_as_json = serde_json::to_string(&object)?;
  let msg_id: String = conn
    .xadd(
      "tasks_stream",
      "*",
      &[
        (StreamKeys::Payload.as_ref(), body_as_json.as_str()),
        (StreamKeys::RequestId.as_ref(), request_id.as_str()),
        (StreamKeys::Action.as_ref(), CrudActions::Read.as_ref()),
      ],
    )
    .await?;

  info!("Message added to 'tasks_stream' with ID: {}", msg_id);

  let response_key = format!("response:{}", request_id);
  let timeout = 30.0; // Timeout in seconds
  let result: RedisResult<Option<(String, String)>> = conn.brpop(&response_key, timeout).await;
  match result {
    Ok(Some((key, value))) => {
      let parsed = serde_json::from_str::<Task>(&value).map_err(|e| {
        error!("error from redis service: {}", e);
        AppError::NotFound("No found".into())
      })?;
      Ok(Json(parsed))
    }
    Ok(None) => Err(AppError::GatewayTimeout),
    Err(e) => {
      error!("error from redis {:?}", e);
      Err(AppError::InternalError)
    }
  }
}

/// Delete Task by given path variable id.
///
/// This ednpoint needs `api_key` authentication in order to call. Api key can be found from README.md.
///
/// Api will delete `Task` by the provided id and return success 200.
/// If storage does not contain `Task` with given id 404 not found will be returned.
#[utoipa::path(
  delete,
  path = "/api/task-redis-response/{id}",
  tag = "Tasks Redis response",
  responses(
(status = 200, description = "Task deleted successfully"),
    // TODO add unauthorized response
    // (status = 401, description = "Unauthorized to delete Task", body = ErrorResponse, example = json!(ErrorResponse::Unauthorized(String::from("missing api key")))),
    // (status = 404, description = "Task not found by id", body = ErrorResponse, example = json!(ErrorResponse::NotFound(format!(
    // "not found id = {}",
    // 1
    // ))))
  ),
  params(
("id", description = "Unique id of Task")
  ),
  security(
("api_key" = [])
  )
)]
pub async fn delete_task(
  Path(id): Path<String>,
  app_state: State<AppState>,
) -> Result<StatusCode, AppError> {
  let request_id = Uuid::new_v4().to_string();

  let mut conn = app_state.redis.get().await?;

  let object = DeleteDto::new(id);

  let body_as_json = serde_json::to_string(&object)?;
  let msg_id: String = conn
    .xadd(
      "tasks_stream",
      "*",
      &[
        (StreamKeys::Payload.as_ref(), body_as_json.as_str()),
        (StreamKeys::RequestId.as_ref(), request_id.as_str()),
        (StreamKeys::Action.as_ref(), CrudActions::Delete.as_ref()),
      ],
    )
    .await?;

  info!("Message added to 'tasks_stream' with ID: {}", msg_id);

  let response_key = format!("response:{}", request_id);
  let timeout = 30.0; // Timeout in seconds
  let result: RedisResult<Option<(String, String)>> = conn.brpop(&response_key, timeout).await;
  match result {
    Ok(Some((key, value))) => match serde_json::from_str::<Task>(&value) {
      Ok(task) => {
        info!("deleted item: {:?}", task);
        Ok(StatusCode::OK)
      }
      Err(e) => Err(AppError::SerdeJson(e)),
    },
    Ok(None) => Err(AppError::AnyhowError(anyhow::anyhow!(
            "Timed out waiting for task creation responses"
        ))),
    Err(e) => {
      error!("error from redis {:?}", e);
      Err(AppError::InternalError)
    }
  }
}

#[utoipa::path(
post,
path = "/api/task-redis-response",
tag = "Tasks Redis response",
request_body = CreateTask,
responses(
(status = 201, description = "Task created successfully"),
)
)]
pub async fn create_task_redis(
  app_state: State<AppState>,
  Json(body): Json<CreateTask>,
  // ) -> impl IntoResponse {
) -> Result<Json<Task>, AppError> {
  body.validate()?;
  let mut conn = app_state.redis.get().await?;

  let request_id = Uuid::new_v4().to_string();

  let body_as_json = serde_json::to_string(&body)?;
  let msg_id: String = conn
    .xadd(
      "tasks_stream",
      "*",
      &[
        (StreamKeys::Payload.as_ref(), body_as_json.as_str()),
        (StreamKeys::RequestId.as_ref(), request_id.as_str()),
        (StreamKeys::Action.as_ref(), CrudActions::Create.as_ref()),
      ],
    )
    .await?;

  info!("Message added to 'tasks_stream' with ID: {}", msg_id);

  // Step 6: Block on BRPOP on "response:<request_id>" with a timeout (e.g., 30 seconds)
  let response_key = format!("response:{}", request_id);
  let timeout = 30.0; // Timeout in seconds
  let result: RedisResult<Option<(String, String)>> = conn.brpop(&response_key, timeout).await;
  match result {
    Ok(Some((key, value))) => match serde_json::from_str::<Task>(&value) {
      Ok(task) => Ok(Json(task)),
      Err(e) => Err(AppError::SerdeJson(e)),
    },
    Ok(None) => Err(AppError::AnyhowError(anyhow::anyhow!(
            "Timed out waiting for task creation responses"
        ))),
    // Ok(None) => (
    //     StatusCode::GATEWAY_TIMEOUT,
    //     "Timed out waiting for task creation response".to_string(),
    // )
    //     .into_response(), // Timeout occurred
    Err(e) => {
      error!("error from redis {:?}", e);
      Err(AppError::InternalError)
    } //   (
    //     StatusCode::INTERNAL_SERVER_ERROR,
    //     format!("Failed to BRPOP for response: {}", e),
    // )
    //     .into_response(),
  }
}

/// Drop Task collection.
///
/// Api will delete all `Task` and return success 200.
/// If storage does not contain `Task` with given id 404 not found will be returned.
#[utoipa::path(
  delete,
  path = "/api/task-redis-response",
  tag = "Tasks Redis response",
  responses(
(status = 200, description = "Task deleted successfully"),
  ),
)]
pub async fn drop_tasks(app_state: State<AppState>) -> Result<(StatusCode, String), AppError> {
  let mut conn = app_state.redis.get().await?;

  let request_id = Uuid::new_v4().to_string();

  let msg_id: String = conn
    .xadd(
      "tasks_stream",
      "*",
      &[
        (StreamKeys::Payload.as_ref(), ""),
        (StreamKeys::RequestId.as_ref(), request_id.as_str()),
        (StreamKeys::Action.as_ref(), CrudActions::Drop.as_ref()),
      ],
    )
    .await?;

  info!("Message added to 'tasks_stream' with ID: {}", msg_id);

  // Step 6: Block on BRPOP on "response:<request_id>" with a timeout (e.g., 30 seconds)
  let response_key = format!("response:{}", request_id);
  let timeout = 30.0; // Timeout in seconds
  let result: RedisResult<Option<(String, String)>> = conn.brpop(&response_key, timeout).await;
  match result {
    Ok(Some((key, value))) => match serde_json::from_str::<String>(&value) {
      Ok(message) => Ok((StatusCode::OK, message)),
      Err(e) => {
        error!("error: {}", e);
        Err(AppError::SerdeJson(e))
      }
    },
    Ok(None) => Err(AppError::AnyhowError(anyhow::anyhow!(
            "Timed out waiting for task creation responses"
        ))),
    Err(e) => {
      error!("error from redis {:?}", e);
      Err(AppError::InternalError)
    }
  }
}

/// Update Task with given id.
///
/// This endpoint supports optional authentication.
///
/// Tries to update `Task` by given id as path variable. If todo is found by id values are
/// updated according `UpdateTask` and updated `Task` is returned with status 200.
/// If todo is not found then 404 not found is returned.
#[utoipa::path(
put,
path = "/api/task-redis-response/{id}",
tag = "Tasks Redis response",
request_body = UpdateTask,
responses(
(status = 200, description = "Success", body = Task),
(
    status = 400,
    description = "Bad Request",
    body = ApiErrorMessage,
    example = json!({
        "status": 400,
        "error": "Validation Error",
        "message": "Validation failed for the provided input.",
        "details": {
            "title": [
                {
                    "code": "length",
                    "message": "Title must be at least 2 characters long",
                    "params": {
                        "min": 2,
                        "value": "title"
                    }
                }
            ]
        }
    })
),
(
    status = 404,
    description = "Task not found",
    body = ApiErrorMessage,
    example = json!({
        "status": 404,
        "error": "Not Found",
        "message": "Task with ID 00000000-0000-0000-0000-000000000000 not found",
        "details": null
    })
),
(
    status = 500,
    description = "Internal Server Error",
    body = ApiErrorMessage,
    example = json!({
        "status": 500,
        "error": "Internal Server Error",
        "message": "An unexpected error occurred.",
        "details": null
    })
),
),
params(
("id", description = "Unique storage id of Task")
),
security(
(),
("api_key" = [])
)
)]
pub async fn update_task(
  app_state: State<AppState>,
  Path(id): Path<String>,
  Json(body): Json<UpdateTask>,
) -> Result<StatusCode, AppError> {
  // Validate
  body.validate()?;
  let mut conn = app_state.redis.get().await?;

  // Combine `id` and `body` into a single JSON structure.
  let payload = serde_json::json!({
        "id": id,
        "data": body
    });
  // Convert the JSON to a string for publishing
  let payload_str = payload.to_string();
  // redis pubsub
  let () = conn.publish("task:update", payload_str).await?;

  Ok(StatusCode::OK)
}
