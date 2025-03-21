use super::controller::{
    create_task_redis, delete_task, drop_tasks, get_task, get_tasks, update_task,
};
use super::model::Task;
use crate::app_state::AppState;
pub use axum::{routing, Router};
use proc_macros::DbResource;

/// Task router - includes full CRUD
pub fn router() -> Router<AppState> {
    Router::new()
        .route(
            &format!("{}-redis-pubsub", Task::URL),
            routing::get(get_tasks)
                .delete(drop_tasks)
                .post(create_task_redis),
        )
        .route(
            &format!("{}-redis-pubsub/{{id}}", Task::URL),
            routing::get(get_task).put(update_task).delete(delete_task),
        )
}
