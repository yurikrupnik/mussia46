use super::controller::{create_task, update_task, delete_task, get_task, get_tasks, drop_tasks};
use crate::app_state::AppState;
pub use axum::{routing, Router};
use super::model::Task;
use proc_macros::DbResource;

/// Task router - includes full CRUD
pub fn router() -> Router<AppState> {
  Router::new()
    .route(
      Task::URL,
      routing::get(get_tasks).delete(drop_tasks).post(create_task),
    )
    .route(
      Task::URL_WITH_ID,
      routing::get(get_task).put(update_task).delete(delete_task),
    )
}
