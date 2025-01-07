use super::controller::{create_book, delete_book, drop_books, get_book, get_books, update_book};
use crate::app_state::AppState;
pub use axum::{routing, Router};
use models::book::Book;
use proc_macros::DbResource;

/// Book router - includes full CRUD
pub fn router() -> Router<AppState> {
  Router::new()
    .route(
      Book::URL,
      routing::get(get_books).delete(drop_books).post(create_book),
    )
    .route(
      &format!("{}/:id", Book::URL),
      routing::put(update_book).get(get_book).delete(delete_book),
    )
}
