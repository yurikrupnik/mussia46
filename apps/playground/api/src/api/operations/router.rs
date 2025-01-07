use super::controller::{
  create_bucket, delete, delete_bucket, generate, read_buckets, read_data, write_data,
};
use crate::app_state::AppState;
use axum::{routing, Router};

/// SQL `Book` router - includes full CRUD
pub fn router() -> Router<AppState> {
  Router::new()
    .route(
      "/db",
      routing::post(write_data).get(read_data),
      // routing::get(get_books).post(create_book).delete(drop_books),
    )
    .route("/db/{id}", routing::delete(delete))
    .route("/db/generate", routing::get(generate))
    .route("/db/bucket", routing::get(read_buckets).post(create_bucket))
    .route("/db/bucket/{id}", routing::delete(delete_bucket))
}
