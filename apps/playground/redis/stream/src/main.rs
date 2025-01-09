use models::streams::{
  Stream, CREATE, DELETE, GROUP_NAME, REDIS_STREAMS, TASKS_STREAM, UPDATE, USERS_STREAM,
};
use models::task::{CreateTask, Task};
use services::postgres::{connector::connect, service::create_item};
use generals::tracing::init_tracing;

// Way 3 = streams with single process
use redis::Value;
use std::error::Error;

// Define your streams and group
// static REDIS_STREAMS: [&str; 2] = ["users_stream", "tasks_stream"];
// static GROUP_NAME: &str = "mygroup";

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
  // Set up the logging system
  init_tracing();
  // Generate a unique consumer name, e.g., using hostname or UUID
  let consumer_name = format!("consumer-{}", uuid::Uuid::new_v4());

  let postgres = connect(None, None).await?;
  // Create a Redis client and get a normal async connection
  let redis_client = redis::Client::open("redis://127.0.0.1/")?;
  let mut conn = redis_client.get_multiplexed_async_connection().await?;

  println!(
    "Listening to Redis streams: {:?} as group '{}' with consumer '{}'",
    REDIS_STREAMS, GROUP_NAME, consumer_name
  );

  loop {
    // XREADGROUP GROUP mygroup consumer-uuid BLOCK 0 STREAMS users_stream tasks_stream >
    let result: redis::RedisResult<Vec<(String, Vec<(String, Value)>)>> =
      redis::cmd("XREADGROUP")
        .arg("GROUP")
        .arg(GROUP_NAME)
        .arg(&consumer_name)
        .arg("BLOCK")
        .arg("0") // block indefinitely
        .arg("STREAMS")
        // .arg(REDIS_STREAMS[0])
        // .arg(REDIS_STREAMS[0])
        // .arg(Stream::Tasks.as_str())
        // .arg(Stream::Users.as_str())
        .arg(USERS_STREAM)
        .arg(TASKS_STREAM)
        .arg(">")
        .arg(">")
        .query_async(&mut conn)
        .await;

    match result {
      Ok(streams) => {
        // Process each stream's entries
        for (stream_key, entries) in streams {
          for (msg_id, value) in entries {
            // Deserialize the fields
            let fields: Vec<(String, String)> = redis::from_redis_value(&value)?;
            let (action, payload) = &fields[0];
            println!(
              "Received message from stream '{}' with ID={}",
              stream_key, msg_id
            );
            println!("action: {:?}", action);

            // Process the message based on stream
            match stream_key.as_str() {
              // match Stream::from_str(stream_key.as_str()) {
              //     Ok(Stream::Users) => {
              USERS_STREAM => {
                // "users_stream" => {
                // println!("Processing user-related event: {:?}", fields);
                // Implement your user event logic here
              }
              TASKS_STREAM => {
                match action.as_str() {
                  CREATE => {
                    let data: CreateTask = serde_json::from_str(payload)?;
                    create_item::<Task, CreateTask>(&postgres, &data).await?;
                  }
                  DELETE => {
                    println!("action: delete")
                  }
                  _ => {}
                }
                // println!("Processing task-related event: {:?}", payload);
              }
              _ => {
                println!("Unknown stream: {}", stream_key);
              }
            }

            // Acknowledge the message
            let ack_result: redis::RedisResult<u64> = redis::cmd("XACK")
              .arg(&stream_key)
              .arg(GROUP_NAME)
              .arg(&msg_id)
              .query_async(&mut conn)
              .await;

            match ack_result {
              Ok(count) => {
                println!(
                  "Acknowledged message with ID={} in stream='{}' (count={})",
                  msg_id, stream_key, count
                );
              }
              Err(e) => {
                eprintln!("Failed to acknowledge message {}: {:?}", msg_id, e);
              }
            }
            // After acknowledging messages, trim the stream
            let trim_result: redis::RedisResult<u64> = redis::cmd("XTRIM")
              .arg(&stream_key)
              .arg("MAXLEN")
              .arg("~")
              .arg("1000") // Keeps approximately 1000 entries
              .query_async(&mut conn)
              .await;

            match trim_result {
              Ok(trimmed) => {
                println!(
                  "Trimmed stream '{}' to approximately 1000 entries (result={})",
                  stream_key, trimmed
                );
              }
              Err(e) => {
                eprintln!("Failed to trim stream '{}': {:?}", stream_key, e);
              }
            }
          }
        }
      }
      Err(e) => {
        eprintln!("Error reading from Redis streams: {:?}", e);
        // Optionally implement retry logic or delay
      }
    }
  }
}

// Way 2 with stream
// use redis::{FromRedisValue, Value};
// use std::error::Error;
//
// // We'll read from these two streams
// static REDIS_STREAMS: [&str; 2] = ["users_stream", "tasks_stream"];
//
// #[tokio::main]
// async fn main() -> Result<(), Box<dyn Error>> {
//     // Create a Redis client and get a normal async connection (not PubSub)
//     let redis_client = redis::Client::open("redis://127.0.0.1/")?;
//     let mut conn = redis_client.get_async_connection().await?;
//
//     println!("Listening to Redis streams: {:?}", REDIS_STREAMS);
//
//     loop {
//         // XREAD BLOCK 0 STREAMS users_stream tasks_stream $ $
//         let result: redis::RedisResult<Vec<(String, Vec<(String, Value)>)>> = redis::cmd("XREAD")
//             .arg("BLOCK")
//             .arg("0") // block indefinitely
//             .arg("STREAMS")
//             .arg(REDIS_STREAMS[0])
//             .arg(REDIS_STREAMS[1])
//             .arg("$")
//             .arg("$")
//             .query_async(&mut conn)
//             .await;
//
//         match result {
//             Ok(streams) => {
//                 // streams is a Vec of (stream_key, Vec<(message_id, redis::Value)>)
//                 for (stream_key, entries) in streams {
//                     for (msg_id, value) in entries {
//                         // Each "value" is typically a redis::Value that represents fields
//                         // Convert redis::Value -> Vec<(String, String)> or similar
//                         let fields: Vec<(String, String)> = redis::from_redis_value(&value)?;
//
//                         // println!(
//                         //     "Received message from stream '{}' with ID={}",
//                         //     stream_key, msg_id
//                         // );
//                         // let data = fields[0].1;
//                         println!("Fields: {:?}", fields);
//                         let stream = stream_key.clone();
//                         match stream_key.as_str() {
//                             "users_stream" => {
//                                 println!("Processing user-related event: {:?}", fields);
//                                 // handle user stream logic
//                             }
//                             "tasks_stream" => {
//                                 println!("Processing task-related event: {:?}", fields);
//                                 // handle tasks stream logic
//                             }
//                             _ => {
//                                 println!("Unknown stream: {}", stream_key);
//                             }
//                         }
//                         // Acknowledge - todo fails = see redis ui
//                     }
//                 }
//             }
//             Err(e) => {
//                 eprintln!("Error reading from Redis streams: {:?}", e);
//                 // You might want to retry or panic, depending on your use case
//             }
//         }
//     }
// }
