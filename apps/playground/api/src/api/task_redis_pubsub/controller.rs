use super::model::{CreateTask, Task, UpdateTask};
use crate::app_state::AppState;
use axum::{
    extract::{Json, Path, State},
    http::StatusCode,
    response::IntoResponse,
};
// use bb8::{PooledConnection, RunError};
// use bb8_redis::RedisConnectionManager;
use models::streams::{
    Stream, CREATE, DELETE, PAYLOAD, REDIS_STREAMS, TASKS_STREAM, UPDATE, USERS_STREAM,
};
use redis::{AsyncCommands, RedisError, RedisResult};
use services::postgres::{
    results::{handle_delete_result, handle_drop_result, handle_result},
    service::{create_item, delete_by_id, drop_collection, get_by_id, get_list, update_by_id},
};
use shared::errors::{ApiErrorMessage, AppError as ServerError, AppError};
use sqlx::encode::IsNull::No;
use tracing::{debug, error, info, instrument, span, warn, Level};
use uuid::Uuid;
use validator::Validate;

#[utoipa::path(
  get,
  path = "/api/task-redis-pubsub",
  tag = "Tasks Redis PubSub",
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
  path = "/api/task-redis-pubsub/{id}",
  tag = "Tasks Redis PubSub",
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
) -> impl IntoResponse {
    // Parse the id as a UUID
    let item_id = match Uuid::parse_str(&id) {
        Ok(id) => id,
        Err(_) => return (StatusCode::BAD_REQUEST, "Invalid UUID format").into_response(),
    };
    // fetch the item from the database
    let result = get_by_id::<Task>(&app_state.pool, &item_id).await;
    // return the result of the query
    handle_result(result, StatusCode::OK)
}

/// Delete Task by given path variable id.
///
/// This ednpoint needs `api_key` authentication in order to call. Api key can be found from README.md.
///
/// Api will delete `Task` by the provided id and return success 200.
/// If storage does not contain `Task` with given id 404 not found will be returned.
#[utoipa::path(
  delete,
  path = "/api/task-redis-pubsub/{id}",
  tag = "Tasks Redis PubSub",
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
    let mut conn = app_state.redis.get()?;
    let () = conn.publish("task:delete", &id).await?;
    Ok(StatusCode::OK)
}

#[utoipa::path(
post,
path = "/api/task-redis-pubsub",
tag = "Tasks Redis PubSub",
request_body = CreateTask,
responses(
(status = 201, description = "Task created successfully"),
)
)]
pub async fn create_task_redis(
    app_state: State<AppState>,
    Json(body): Json<CreateTask>,
) -> Result<StatusCode, AppError> {
    body.validate()?;
    let mut conn = app_state.redis.get()?;

    // redis pubsub
    let () = conn.publish("task:create", &body).await?;

    Ok(StatusCode::CREATED)
}

/// Drop Task collection via pubsub.
///
/// Api will delete all `Task` and return success 200.
/// If storage does not contain `Task` with given id 404 not found will be returned.
#[utoipa::path(
  delete,
  path = "/api/task-redis-pubsub",
  tag = "Tasks Redis PubSub",
  responses(
(status = 200, description = "Task deleted successfully"),
  ),
)]
pub async fn drop_tasks(app_state: State<AppState>) -> Result<StatusCode, AppError> {
    let mut conn = app_state.redis.get()?;
    // redis pubsub
    let () = conn.publish("task:drop", "".to_string()).await?;

    Ok(StatusCode::OK)
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
path = "/api/task-redis-pubsub/{id}",
tag = "Tasks Redis PubSub",
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
    // establish redis connection
    let mut conn = app_state.redis.get()?;

    // Combine `id` and `body` into a single JSON structure.
    let payload = serde_json::json!({
        "id": id,
        "data": body
    });
    // Convert the JSON to a string for publishing
    let payload_str = payload.to_string();
    // send redis pubsub
    let () = conn.publish("task:update", payload_str).await?;

    Ok(StatusCode::OK)
}
