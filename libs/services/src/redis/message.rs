// use super::acknowledge::acknowledge_message;
// use super::push_response::push_response;
// use crate::postgres::service::{create_item, delete_by_id};
//
// // use axum_utils::errors::{ApiErrorMessage, ApiResponse, AppError};
// use bb8::PooledConnection;
// use bb8_redis::RedisConnectionManager;
// use proc_macros::DbResource;
// use redis::Value;
// use sqlx::types::Uuid;
// use tracing::{error, info};
//
// pub async fn handle_message<'a, T, C, U>(
//     stream_key: &str,
//     msg_id: &str,
//     redis_value: Value,
//     postgres_pool: &sqlx::Pool<sqlx::Postgres>,
//     mut redis_conn: PooledConnection<'a, RedisConnectionManager>,
// ) -> anyhow::Result<()>
// where
//     T: DbResource
//         + serde::Serialize
//         + Send
//         + Unpin
//         + Sync
//         + for<'r> sqlx::FromRow<'r, sqlx::postgres::PgRow>,
//     C: serde::Serialize + serde::de::DeserializeOwned, //serde::Deserialize<'a>,
//     U: serde::Serialize,
// {
//     // Deserialize fields into Vec<(String, String)>
//     let fields: Vec<(String, String)> = redis::from_redis_value(&redis_value)?;
//
//     info!(
//         "Received message from stream '{}' with ID={}",
//         stream_key, msg_id
//     );
//     info!("Fields: {:?}", fields);
//
//     let mut payload_json = None;
//     let mut request_id = None;
//     let mut action = None;
//
//     for (key, value) in fields {
//         match key.as_str() {
//             "payload" => {
//                 payload_json = Some(value);
//             }
//             "request_id" => {
//                 request_id = Some(value);
//             }
//             "action" => {
//                 action = Some(value);
//             }
//             _ => {}
//         }
//     }
//
//     // Basic validation
//     let payload_json = match payload_json {
//         Some(p) => p,
//         None => {
//             error!("Missing 'payload' in message {}", msg_id);
//             return Ok(());
//         }
//     };
//     let request_id = match request_id {
//         Some(r) => r,
//         None => {
//             error!("Missing 'request_id' in message {}", msg_id);
//             return Ok(());
//         }
//     };
//     let action = match action {
//         Some(a) => a,
//         None => {
//             error!("Missing 'action' in message {}", msg_id);
//             return Ok(());
//         }
//     };
//
//     // Route to the appropriate handler function
//     let response_json = match action.as_str() {
//         "create" => {
//             // Create a new item in the database
//             let create_task: C = serde_json::from_str(&payload_json)?;
//             let created_task = create_item::<T, C>(postgres_pool, &create_task).await?;
//             Some(serde_json::to_string(&created_task)?)
//         }
//
//         "update" => {
//             // Update an existing item in the database
//             // let update_task: UpdateTask = serde_json::from_str(&payload_json)?;
//             // let updated_task = update_by_id::<Task, UpdateTask>(postgres_pool, update_task).await?;
//             // Some(serde_json::to_string(&updated_task)?)
//             Some("Da,m".to_string())
//         }
//
//         "delete" => {
//             // Delete an item from the database
//             // For example, we might just have an ID in the payload
//             let task_id: Uuid = serde_json::from_str(&payload_json)?;
//             let deleted_count = delete_by_id::<T>(postgres_pool, &task_id).await?;
//             // Return a small JSON describing how many items got deleted
//             Some(format!(r#"{{"deleted_count": {:?}}}"#, deleted_count))
//         }
//
//         // Add more actions here as needed
//         //
//         // e.g. "mark_as_done", "notify", "archive", etc.
//         _ => {
//             info!("Unknown action '{}'", action);
//             None
//         }
//     };
//
//     // If we have a response, push it back to Redis
//     if let Some(response) = response_json {
//         push_response(redis_conn, &request_id, &response).await?;
//     }
//
//     // Acknowledge the message so it is not re-read
//     // acknowledge_message(redis_conn, stream_key, msg_id, group).await?;
//
//     Ok(())
// }
