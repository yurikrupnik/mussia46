use bb8::PooledConnection;
use bb8_redis::RedisConnectionManager;
use tracing::{error, info};

pub async fn push_response<'a>(
    mut redis_conn: PooledConnection<'a, RedisConnectionManager>,
    // mut redis_conn: PooledConnection<'a, RedisConnectionManager>,
    // redis_conn: &mut redis::aio::Connection,
    request_id: &str,
    response: &str,
) -> anyhow::Result<()> {
    let response_key = format!("response:{}", request_id);
    let push_result: redis::RedisResult<()> = redis::cmd("LPUSH")
        .arg(&response_key)
        .arg(response)
        .query_async(&mut *redis_conn)
        .await;

    match push_result {
        Ok(_) => {
            info!("Pushed response to '{}'", response_key);
        }
        Err(e) => {
            error!("Failed to push response to '{}': {:?}", response_key, e);
        }
    }
    Ok(())
}
