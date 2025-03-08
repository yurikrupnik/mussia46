use super::controller::sse_handler;
use crate::app_state::AppState;
use axum::{routing, Router};

/// see endpoint router
pub fn router() -> Router<AppState> {
    Router::new().route("/see", routing::get(sse_handler))
}
