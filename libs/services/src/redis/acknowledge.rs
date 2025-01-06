use tracing::{error, info};

/// Acknowledges the message in the specified stream.
pub async fn acknowledge_message(
    redis_conn: &mut redis::aio::Connection,
    stream_key: &str,
    msg_id: &str,
    group_name: &str,
) -> anyhow::Result<()> {
    let ack_result: redis::RedisResult<u64> = redis::cmd("XACK")
        .arg(stream_key)
        .arg(group_name)
        .arg(msg_id)
        .query_async(redis_conn)
        .await;

    match ack_result {
        Ok(count) => {
            info!(
                "Acknowledged message with ID={} in stream='{}' (count={})",
                msg_id, stream_key, count
            );
        }
        Err(e) => {
            error!("Failed to acknowledge message {}: {:?}", msg_id, e);
        }
    }
    Ok(())
}
