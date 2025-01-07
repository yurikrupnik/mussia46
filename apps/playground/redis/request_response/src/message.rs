use models::streams::{CrudActions, DeleteDto, ReadDto, StreamKeys};
use proc_macros::DbResource;
use services::postgres::{
  service::{create_item, delete_by_id, get_by_id, get_list, update_by_id},
};
use sqlx;
use tracing::error;
use uuid::Uuid;

pub async fn process_message<T, C>(
  action: &str,
  payload: &str,
  // fields: &Vec<(String, String)>,
  postgres_pool: &sqlx::Pool<sqlx::Postgres>,
  // ) -> anyhow::Result<ApiResponse<String>, ApiResponse<anyhow::Error>> {
) -> anyhow::Result<String>
where
  T: DbResource
  + Send
  + Sync
  + Unpin
  + serde::Serialize
  + for<'r> sqlx::FromRow<'r, sqlx::postgres::PgRow>,
  C: serde::Serialize + for<'a> serde::Deserialize<'a>,
{
  // Parse the action
  let parsed_action = action.parse::<CrudActions>()?;

  // Based on action, do the database or other logic
  match parsed_action {
    CrudActions::Create => {
      let create_task: C = serde_json::from_str(payload)?;
      let db_result = create_item::<T, C>(postgres_pool, &create_task).await?;
      // Turn the Task into JSON
      let json_result = serde_json::to_string(&db_result)?;
      // Ok(ApiResponse::Ok { data: json_result })
      Ok(json_result)
    }
    CrudActions::Read => {
      let data = serde_json::from_str::<ReadDto>(payload)?;
      let id = Uuid::parse_str(&data.id)?;
      let db_result = get_by_id::<T>(postgres_pool, &id)
        .await
        // .map_err(|e| ApiResponse::Error {
        //     error: ApiErrorMessage::not_found(e.to_string()),
        // })
        ?;
      let json_result = serde_json::to_string(&db_result)?;
      Ok(json_result)
      // Ok(ApiResponse::Ok { data: json_result })
    }
    // ... handle other actions similarly ...
    _ => {
      // Fallback for unimplemented actions
      // anyhow::anyhow!("Unrecognized or not implemented")
      Err(anyhow::anyhow!("Unrecognized or not implemented"))
      // Err(ApiResponse::Error {
      //     error: ApiErrorMessage::not_found("no foun shit"),
      // })
    }
  }
}
