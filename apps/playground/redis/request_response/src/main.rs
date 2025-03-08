fn main() {
    println!("asd")
}
// mod message;
//
// use axum::http::StatusCode;
// use generals::tracing::init_tracing;
// use models::streams::{CrudActions, DeleteDto, ReadDto, StreamKeys};
// use models::task::{CreateTask, Task, UpdateTask, UpdateTaskArgs};
// use proc_macros::DbResource;
// use redis::{ErrorKind, Value};
// use services::postgres::service::drop_collection;
// use services::postgres::{
//     connector::connect,
//     service::{create_item, delete_by_id, get_by_id, get_list, update_by_id},
// };
// use services::redis::connector::connect as redis_connect;
// // use services::redis::push_response::push_response;
// use shared::errors::{ApiErrorMessage, ApiResponse, AppError};
// use tokio::time::{sleep, Duration};
// use tracing::{debug, error, info, span, warn, Level};
// use uuid::Uuid;
//
// use message::process_message;
//
// static REDIS_STREAMS: [&str; 2] = ["tasks_stream", "users_stream"];
// static GROUP_NAME: &str = "mygroup";
//
// #[tokio::main]
// async fn main() {
//     // use a custom function that logs or handles all errors
//     if let Err(e) = real_main().await {
//         error!("Unhandled error: {}", e);
//     }
// }
//
// async fn real_main() -> anyhow::Result<()> {
//     // Set up the logging system
//     init_tracing();
//
//     let redis_pool = redis_connect().await?;
//     let mut conn = redis_pool.get().await?;
//     // create Postgres pool
//     let postgres_pool = connect(None, None).await?;
//
//     // Generate a unique consumer name, e.g., using UUID
//     let consumer_name = format!("consumer-{}", Uuid::new_v4());
//
//     info!(
//         "Listening to Redis streams: {:?} as group '{}' with consumer '{}'",
//         REDIS_STREAMS, GROUP_NAME, consumer_name
//     );
//
//     // Attempt to create consumer group; ignore if it already exists
//     for stream in &REDIS_STREAMS {
//         let create_group_result: redis::RedisResult<String> = redis::cmd("XGROUP")
//             .arg("CREATE")
//             .arg(stream)
//             .arg(GROUP_NAME)
//             .arg("$")
//             .arg("MKSTREAM")
//             .query_async(&mut *conn)
//             .await;
//
//         match create_group_result {
//             Ok(_) => info!("Consumer group '{}' created for '{}'", GROUP_NAME, stream),
//             Err(e) => {
//                 if let ErrorKind::ExtensionError = e.kind() {
//                     warn!(
//                         "Consumer group '{}' already exists for '{}'",
//                         GROUP_NAME, stream
//                     );
//                 } else {
//                     error!("Failed to create consumer group for '{}': {:?}", stream, e);
//                     // error!(stream = %stream_key, "Failed to acknowledge message {}", msg_id);
//                 }
//             }
//         }
//     }
//
//     loop {
//         // XREADGROUP GROUP mygroup consumer-uuid BLOCK 5000 STREAMS todo_stream >
//         let result: redis::RedisResult<Vec<(String, Vec<(String, Value)>)>> =
//             redis::cmd("XREADGROUP")
//                 .arg("GROUP")
//                 .arg(GROUP_NAME)
//                 .arg(&consumer_name)
//                 .arg("BLOCK")
//                 .arg("5000") // block for 5 seconds
//                 .arg("STREAMS")
//                 .arg(REDIS_STREAMS[0])
//                 .arg(REDIS_STREAMS[1])
//                 .arg(">")
//                 .arg(">")
//                 .query_async(&mut *conn)
//                 .await;
//
//         match result {
//             Ok(streams) => {
//                 for (stream_key, entries) in streams {
//                     let redis_span = span!(Level::INFO, "redis_stream_handling", stream_key = %stream_key, consumer = %consumer_name);
//                     let _enter = redis_span.enter();
//                     for (msg_id, value) in entries {
//                         // Deserialize fields
//                         let fields: Vec<(String, String)> = redis::from_redis_value(&value)?;
//
//                         info!(
//                             "Received message from stream '{}' with ID={}",
//                             stream_key, msg_id
//                         );
//
//                         // Extract necessary fields
//                         let mut payload_json = None;
//                         let mut request_id = None;
//                         let mut action = None;
//
//                         for (key, value) in &fields {
//                             if let Ok(stream_key_enum) = key.parse::<StreamKeys>() {
//                                 match stream_key_enum {
//                                     StreamKeys::Payload => payload_json = Some(value),
//                                     StreamKeys::RequestId => request_id = Some(value),
//                                     StreamKeys::Action => action = Some(value),
//                                 }
//                             } else {
//                                 error!("Failed to map the data from the event!")
//                             }
//                         }
//
//                         if payload_json.is_none() || request_id.is_none() || action.is_none() {
//                             error!(
//                                 "Missing 'payload' or 'request_id' or 'action' in message {}",
//                                 msg_id
//                             );
//                             continue;
//                         }
//
//                         let payload = payload_json.unwrap();
//                         let request_id = request_id.unwrap();
//                         let action = action.unwrap();
//
//                         let response_json =
//                             process_message::<Task, CreateTask>(action, payload, &postgres_pool)
//                                 .await;
//                         let response_key = format!("response:{}", request_id);
//                         match response_json {
//                             Ok(response) => {
//                                 info!("response: {}", &response);
//
//                                 let push_result: redis::RedisResult<()> = redis::cmd("LPUSH")
//                                     .arg(&response_key)
//                                     .arg(response)
//                                     .query_async(&mut *conn)
//                                     .await;
//
//                                 match push_result {
//                                     Ok(_) => {
//                                         info!("Pushed response to '{}'", response_key);
//                                     }
//                                     Err(e) => {
//                                         error!(
//                                             "Failed to push response to '{}': {:?}",
//                                             response_key, e
//                                         );
//                                     }
//                                 }
//                             }
//                             Err(e) => {
//                                 error!("App error: {}", e);
//                                 let json_result = serde_json::to_string(&e.to_string())?;
//                                 let push_result: redis::RedisResult<()> = redis::cmd("LPUSH")
//                                     .arg(&response_key)
//                                     .arg(json_result)
//                                     .query_async(&mut *conn)
//                                     .await;
//
//                                 match push_result {
//                                     Ok(_) => {
//                                         info!("Pushed response to '{}'", response_key);
//                                     }
//                                     Err(e) => {
//                                         error!(
//                                             "Failed to push response to '{}': {:?}",
//                                             response_key, e
//                                         );
//                                     }
//                                 }
//                             }
//                         }
//                         // push the `response_json` back to redis
//                         // If we have a response, push it back to Redis
//                         // if let Ok(response) = response_json {
//                         //     // push_response(conn, &request_id, &response).await?;
//                         //     let response_key = format!("response:{}", request_id);
//                         //     info!("response: {}", response);
//                         //     let push_result: redis::RedisResult<()> = redis::cmd("LPUSH")
//                         //         .arg(&response_key)
//                         //         .arg(response)
//                         //         .query_async(&mut *conn)
//                         //         .await;
//                         //
//                         //     match push_result {
//                         //         Ok(_) => {
//                         //             info!("Pushed response to '{}'", response_key);
//                         //         }
//                         //         Err(e) => {
//                         //             error!(
//                         //                 "Failed to push response to '{}': {:?}",
//                         //                 response_key, e
//                         //             );
//                         //         }
//                         //     }
//                         // } else {
//                         //     error!("shit happened here");
//                         // }
//                         // Acknowledge the message
//                         let ack_result: redis::RedisResult<u64> = redis::cmd("XACK")
//                             .arg(&stream_key)
//                             .arg(GROUP_NAME)
//                             .arg(&msg_id)
//                             .query_async(&mut *conn)
//                             .await;
//
//                         match ack_result {
//                             Ok(count) => {
//                                 info!(
//                                     "Acknowledged message with ID={} in stream='{}' (count={})",
//                                     msg_id, stream_key, count
//                                 );
//                             }
//                             Err(e) => {
//                                 error!("Failed to acknowledge message {}: {:?}", msg_id, e);
//                             }
//                         }
//
//                         // Trim the stream to keep it manageable
//                         // let trim_result: redis::RedisResult<u64> = redis::cmd("XTRIM")
//                         //     .arg(&stream_key)
//                         //     .arg("MAXLEN")
//                         //     .arg("~")
//                         //     .arg(1000) // Keeps approximately 1000 entries
//                         //     .query_async(&mut *conn)
//                         //     .await;
//                         //
//                         // match trim_result {
//                         //     Ok(trimmed) => {
//                         //         info!(
//                         //             "Trimmed stream '{}' to approximately 1000 entries (result={})",
//                         //             stream_key, trimmed
//                         //         );
//                         //     }
//                         //     Err(e) => {
//                         //         error!("Failed to trim stream '{}': {:?}", stream_key, e);
//                         //     }
//                         // }
//                     }
//                 }
//             }
//             Err(e) => {
//                 eprintln!("Error reading from Redis streams: {:?}", e);
//                 // Optionally implement retry logic or a short sleep before retrying
//                 sleep(Duration::from_secs(1)).await;
//             }
//         }
//     }
// }
