use super::model::{CreateTask, Task, UpdateTask};
use crate::app_state::AppState;
use axum::{
  extract::{Json, Path, State},
  http::StatusCode,
  response::IntoResponse,
};
use shared::errors::{ApiErrorMessage, AppError as ServerError};
use tracing::{debug, error, info, instrument, span, warn, Level};
use models::streams::{
  Stream, CREATE, DELETE, PAYLOAD, REDIS_STREAMS, TASKS_STREAM, UPDATE, USERS_STREAM,
};
use redis::{AsyncCommands, RedisResult};
use services::postgres::{
  results::{handle_delete_result, handle_drop_result, handle_result},
  service::{create_item, delete_by_id, drop_collection, get_by_id, get_list, update_by_id},
};
use uuid::Uuid;
use validator::Validate;
use generals::envs::Env;

/// Get list of tasks.
///
/// List `Task`.
///
/// One could call the api endpoint with following curl.
/// ```text
/// curl localhost:8080/api/task
/// ```
#[utoipa::path(
  get,
  path = "/api/task",
  tag = "Tasks",
  responses(
(status = 200, description = "Collection found successfully", body = [Task]),
    // (status = 400, description = "Api error", body = ErrorResponse),
    // (status = 500, description = "Internal error", body = ErrorResponse),
  ),
)]
pub async fn get_tasks(State(app_state): State<AppState>) -> impl IntoResponse {
  // let query = "where title = 'ariss'";
  // let query = "where title = 'ariss'";
  let result = get_list::<Task>(&app_state.pool, &None).await;
  // let result = get_list::<Task>(&app_state.pool, Some(query)).await;
  handle_result(result, StatusCode::OK)
}

/// Get Task by id.
///
/// Return found `Task` with status 200 or 404 not found if `Task` is not found from Postgres DB.
#[utoipa::path(
  get,
  path = "/api/task/{id}",
  tag = "Tasks",
  responses(
(status = 200, description = "Task found from db", body = Task),
    // (status = 404, description = "Task not found by id", body = ErrorResponse, example = json!(ErrorResponse::NotFound(String::from("id = 1"))))
  ),
  params(
("id", description = "Unique storage id of Task")
  )
)]
pub async fn get_task(
  Path(id): Path<String>,
  State(app_state): State<AppState>,
) -> impl IntoResponse {
  info!("Get task by id: {}", &id);
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
  path = "/api/task/{id}",
  tag = "Tasks",
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
pub async fn delete_task(Path(id): Path<String>, app_state: State<AppState>) -> impl IntoResponse {
  // Parse the id as a UUID
  let item_id = match Uuid::parse_str(&id) {
    Ok(id) => id,
    Err(_) => return (StatusCode::BAD_REQUEST, "Invalid UUID format").into_response(),
  };
  let result = delete_by_id::<Task>(&app_state.pool, &item_id).await;
  handle_delete_result(result, &item_id.to_string())
}

/// Create new Task.
///
/// Post a new `Task` in request body as json to store it. Api will return
/// created `Task` on success.
///
/// One could call the api with following curl.
/// ```text
/// curl -X POST -H "Content-Type: application/json" -d '{"firstName": "Test name", "lastName": "Test last", "email": "a@a.com", "username": "test"}' localhost:8080/api/task
/// ```
#[utoipa::path(
post,
path = "/api/task",
tag = "Tasks",
request_body = CreateTask,
responses(
(status = 201, description = "Task created successfully", body = Task),
)
)]
pub async fn create_task(
  app_state: State<AppState>,
  Json(body): Json<CreateTask>,
) -> impl IntoResponse {
  if let Err(error) = body.validate() {
    return (StatusCode::BAD_REQUEST, Json(error)).into_response();
  }
  // let mut conna = app_state.redis.get().await.expect("dam shit");
  // Step 3: Get a Redis connection from the pool
  // let mut conn = match app_state.redis.get().await {
  //     Ok(conn) => conn,
  //     Err(e) => {
  //         return (
  //             StatusCode::INTERNAL_SERVER_ERROR,
  //             format!("Failed to get Redis connection: {}", e),
  //         )
  //             .into_response();
  //     }
  // };
  let redis_client = redis::Client::open(Env::get_redis().unwrap()).expect("failed to connect redis");
  let mut conn = redis_client
      .get_multiplexed_async_connection()
      .await
      .expect("failed here");
  let () = conn.publish("task:create", &body).await.unwrap();

  // let request_id = Uuid::new_v4().to_string();

  // let body_as_json = match serde_json::to_string(&body) {
  //   Ok(json) => json,
  //   Err(e) => {
  //     return (
  //       StatusCode::INTERNAL_SERVER_ERROR,
  //       format!("Failed to serialize body: {}", e),
  //     )
  //       .into_response();
  //   }
  // };
  // let action = "create";
  // let msg_id: String = match conna
  //   .xadd("tasks_stream", "*", &[("payload", &body_as_json), ("request_id", &request_id), ("action", &action.to_string())])
  //   .await
  // {
  //   Ok(id) => id,
  //   Err(e) => {
  //     return (
  //       StatusCode::INTERNAL_SERVER_ERROR,
  //       format!("Failed to XADD message to Redis stream: {}", e),
  //     )
  //       .into_response()
  //   }
  // };

  // info!("Message added to 'todo_stream' with ID: {}", msg_id);
  //
  // // Step 6: Block on BRPOP on "response:<request_id>" with a timeout (e.g., 30 seconds)
  // let response_key = format!("response:{}", request_id);
  // let timeout = 10.0; // Timeout in seconds
  // let result: RedisResult<Option<(String, String)>> = conna.brpop(&response_key, timeout).await;
  // match result {
  //   Ok(Some((key, value))) => match serde_json::from_str::<Task>(&value) {
  //     Ok(task) => (StatusCode::CREATED, Json(task)).into_response(),
  //     Err(e) => (
  //       StatusCode::INTERNAL_SERVER_ERROR,
  //       format!("Failed to deserialize task: {}", e),
  //     )
  //       .into_response(),
  //   },
  //   Ok(None) => (
  //     StatusCode::GATEWAY_TIMEOUT,
  //     "Timed out waiting for task creation response".to_string(),
  //   )
  //     .into_response(), // Timeout occurred
  //   Err(e) => (
  //     StatusCode::INTERNAL_SERVER_ERROR,
  //     format!("Failed to BRPOP for response: {}", e),
  //   )
  //     .into_response(),
  // }

  // redis pubsub
  let () = conn.publish("users_topic", &body).await.unwrap();
  // working steam
  // let msg_id: String = match conn.xadd(TASKS_STREAM, "*", &[(CREATE, &body)]).await {
  //     // let msg_id: String = match conn.xadd("tasks_stream", "*", &[("payload", &body)]).await {
  //     Ok(id) => id,
  //     Err(e) => {
  //         return (
  //             StatusCode::INTERNAL_SERVER_ERROR,
  //             format!("Failed to XADD message to Redis stream: {e}"),
  //         )
  //             .into_response();
  //     }
  // };
  // // end of working stream
  // info!("message id: {msg_id}");
  // let result = create_item::<Task, CreateTask>(&app_state.pool, body).await;
  // handle_result(result, StatusCode::CREATED)
  (StatusCode::CREATED).into_response()
}

/// Drop Task collection.
///
/// Api will delete all `Task` and return success 200.
/// If storage does not contain `Task` with given id 404 not found will be returned.
#[utoipa::path(
  delete,
  path = "/api/task",
  tag = "Tasks",
  responses(
(status = 200, description = "Task deleted successfully"),
  ),
)]
pub async fn drop_tasks(app_state: State<AppState>) -> impl IntoResponse {
  let result = drop_collection::<Task>(&app_state.pool).await;
  handle_drop_result(result)
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
path = "/api/task/{id}",
tag = "Tasks",
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
) -> Result<Json<Task>, ServerError> {
  // let fetch_span = span!(Level::INFO, "update_task");
  // let _enter = fetch_span.enter();
  info!("aris is here");
  // Validate
  body.validate()?;
  // Parse the id as a UUID
  let item_id = Uuid::parse_str(&id)?;
  let result = update_by_id::<Task, UpdateTask>(&app_state.pool, &item_id, &body).await?;
  // let task = update_by_id::<Task, UpdateTask>(&app_state.pool, &item_id, body).await?;
  Ok(Json(result))
  // match result {
  //     Ok(payload) => {
  //         info!("Data: {:?}", &payload);
  //         (StatusCode::OK, Json(&payload)).into_response()
  //     }
  //     Err(sqlx::Error::ColumnNotFound(msg)) => {
  //         error!("ColumnNotFoundji: {:?}", &msg);
  //         (StatusCode::BAD_REQUEST, Json(msg)).into_response()
  //     }
  //     Err(e) => {
  //         error!("Error: {:?}", &e.to_string());
  //         (StatusCode::INTERNAL_SERVER_ERROR, Json(&e.to_string())).into_response()
  //     }
  // }
}
