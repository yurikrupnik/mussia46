// use bb8::{Pool, RunError};
use r2d2::{Error, Pool};
// use bb8_redis::{RedisConnectionManager, redis::{cmd, AsyncCommands},};
use generals::envs::Env;
use redis::{Client, Commands, ErrorKind, RedisError, RedisResult};

fn get_redis_uri() -> String {
    Env::get_redis().unwrap()
}

pub async fn connect() -> Result<Pool<Client>, RedisError> {
    // Create a Redis connection manager
    tracing::info!("Attempting to connect to Redis");
    let client = Client::open("redis://127.0.0.1/").unwrap();
    let pool = Pool::builder().build(client).unwrap();
    // let mut conn = pool.get().unwrap();
    // let reply: String = cmd("PING").query_async(&mut *conn).await.unwrap();
    // let ds: String = conn.set("key", "value").unwrap();
    // let s = conn.get("key").unwrap();
    // println!("{s:?}");
    // let reply: String = cmd("PING").query_async(&mut *conn).await.unwrap();

    // assert_eq!("PONG", reply);
    //   let manager = RedisConnectionManager::new(get_redis_uri())
    //       .inspect_err(|e| tracing::error!("Failed to create Redis connection manager: {}", e))?;
    //   })?;

    // Build the connection pool
    // let pool = Pool::builder()
    //     .build(manager)
    //     .await
    //     .inspect_err(|e| tracing::error!("Failed to create Redis connection pool: {}", e))?;

    // // Test the connection by getting a connection and sending a PING command
    // let mut connection = pool.get_owned().await.map_err(|e| match e {
    //     RunError::User(err) => {
    //         tracing::error!("Failed to get a Redis connection from the pool: {}", err);
    //         err
    //     }
    //     RunError::TimedOut => {
    //         let timeout_error = RedisError::from((
    //             ErrorKind::IoError,
    //             "Connection pool timed out while getting connection",
    //         ));
    //         tracing::error!("Connection pool operation timed out: {}", timeout_error);
    //         timeout_error
    //     }
    // })?;
    //     redis::cmd("PING").await?;
    // .query_async::<String>(&mut *connection)
    // .await
    // .map_err(|e| {
    //     tracing::error!("Failed to communicate with Redis: {}", e);
    //     e
    // })?;
    tracing::info!("Successfully connected to Redis");
    Ok(pool)
}

// #[cfg(test)]
// mod tests {
//     use super::*;
//     use std::mem::transmute;
//     // todo test
//
//     // #[tokio::test]
//     // async fn test_connect() -> Result<(), RedisError> {
//     //   // let db_name = "test_db";
//     //   let pool = connect().await?;
//     //
//     //   // assert_eq!(pool.get_owned(), transmute(pool.get_owned()));
//     //   Ok(())
//     // }
// }
