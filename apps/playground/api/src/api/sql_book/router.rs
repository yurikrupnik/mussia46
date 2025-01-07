use super::controller::{create_book, delete_book, drop_books, get_book, get_books, update_book};
use crate::app_state::AppState;
use axum::{routing, Router};

/// SQL `Book` router - includes full CRUD
pub fn router() -> Router<AppState> {
  Router::new()
    .route(
      "/sql-book",
      routing::get(get_books).post(create_book).delete(drop_books),
    )
    .route(
      "/sql-book/:id",
      routing::get(get_book).put(update_book).delete(delete_book),
    )
}
