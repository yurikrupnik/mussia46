use futures::StreamExt;
use generals::{envs::Env, tracing::init_tracing};
use models::task::{CreateTask, Task, UpdateTask};
use redis::Client;
use services::postgres::service::{drop_collection, update_by_id};
use services::postgres::{
    connector::connect as connect_postgres,
    service::{create_item, delete_by_id},
};
use tracing::{error, info};
use uuid::Uuid;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    // Set up the logging system
    init_tracing();
    let redis_client = Client::open(Env::get_redis().unwrap())?;
    let mut pubsub = redis_client.get_async_pubsub().await?;

    let redis_topics = ["task:create", "task:delete", "task:update", "task:drop"];
    let postgres = connect_postgres(None, None).await?;
    for topic in redis_topics {
        pubsub.subscribe(topic).await?;
        info!("subscribed to topic: {topic}");
    }
    info!("Listening for messages on topics: {:?}", redis_topics);

    while let Some(msg) = pubsub.on_message().next().await {
        let topic = msg.get_channel_name();
        let payload: String = msg.get_payload()?;
        match topic {
            "task:create" => {
                info!("Processing task:create event: {}", payload);
                // Deserialize the payload to CreateTask
                let create_task: CreateTask = serde_json::from_str(&payload)?;

                // Insert the task into the database
                info!("Inserting task into the database");
                create_item::<Task, CreateTask>(&postgres, &create_task).await?;
            }
            "task:delete" => {
                info!("Processing task:delete event: {}", payload);
                let id = Uuid::parse_str(&payload)?;
                delete_by_id::<Task>(&postgres, &id).await?;
            }
            "task:update" => {
                info!("Processing task:update event: {}", payload);
                #[derive(Debug, serde::Serialize, serde::Deserialize)]
                struct PubSubPayload {
                    id: String,
                    data: UpdateTask,
                }
                // Deserialize the combined payload
                let parsed: PubSubPayload = serde_json::from_str(&payload)?;
                let id = Uuid::parse_str(&parsed.id)?;
                let data = parsed.data;
                // Update in DB
                update_by_id::<Task, UpdateTask>(&postgres, &id, &data).await?;
            }
            "task:drop" => {
                info!("Processing task:drop event: {}", payload);
                drop_collection::<Task>(&postgres).await?;
            }
            _ => {
                error!("Unknown topic: {}", topic);
            }
        }
    }
    Ok(())
}
