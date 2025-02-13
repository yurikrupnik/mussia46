use crate::app_state::AppState;
use axum::{
    extract::{Json, Path, Query, State},
    http::StatusCode,
    response::IntoResponse,
};
use futures::TryStreamExt;
use mongodb::bson::{doc, from_document};
use mongodb::Collection;
use proc_macros::DbResource;
use services::mongo::filter_and_options::construct_find_options_and_filter;
use services::mongo::service::{
    create_item, delete_by_id, drop_collection, get_by_id, update_by_id,
};
use sqlx::query;
use tracing::{info, trace};
use validator::Validate;

use super::model::{Book, BookListQuery, NewBook, UpdateBook};

// use shared::validation::validate_request_body;

// fn internal_error<E: std::error::Error>(err: E) -> impl IntoResponse {
//     tracing::error!("Internal server error: {}", err);
//     // let labels = [("error", err.to_string())];
//     (
//         StatusCode::INTERNAL_SERVER_ERROR,
//         Json("Internal server error"),
//     )
//         .into_response()
// }

/// Get a book by id
#[utoipa::path(
  get,
  path = "/api/book/{id}",
  tag = Book::TAG,
  responses(
  (status = 200, description = "Book found", body = Book),
  // (status = 404, description = "Book not found", body = HttpError),
  ),
)]
pub async fn get_book(
    State(app_state): State<AppState>,
    Path(id): Path<String>,
) -> impl IntoResponse {
    let db = &app_state.db;
    // let query = query.into_inner();
    // let (filter, options) = construct_find_options_and_filter(query.clone()).unwrap();
    let result = get_by_id::<Book>(db, &id).await;
    match result {
        Ok(Some(payload)) => (StatusCode::OK, Json(&payload)).into_response(),
        Ok(None) => (
            StatusCode::NOT_FOUND,
            Json(&"Newly created item is not found"),
        )
            .into_response(),
        Err(err) => {
            tracing::error!("Internal server error: {}", err);
            (StatusCode::INTERNAL_SERVER_ERROR, Json(&err.to_string())).into_response()
        }
    }
}

/// List all books
#[utoipa::path(
  get,
  path = "/api/book",
  tag = Book::TAG,
  params(BookListQuery),
  responses(
  (status = 200, description = "List of books", body = [Book]),
  ),
)]
pub async fn get_books(
    State(app_state): State<AppState>,
    Query(query): Query<BookListQuery>,
) -> impl IntoResponse {
    let (filter, options) = construct_find_options_and_filter(query.clone()).unwrap();
    let db = &app_state.db;
    let collection: Collection<Book> = db.collection(Book::COLLECTION);
    let mut cursor = collection
        .find(filter)
        .with_options(options)
        .await
        .expect("failed fetching");
    let mut payload: Vec<Book> = Vec::new();
    while let Some(item) = cursor
        .try_next()
        .await
        .expect("Error mapping through cursor")
    {
        payload.push(item);
    }
    info!("payload: {:?}", payload);
    trace!("payload: {:?}", payload);
    (StatusCode::OK, Json(payload)).into_response()
}

/// Create a new Book
#[utoipa::path(
  post,
  path = "/api/book",
  tag = Book::TAG,
  request_body = NewBook,
  responses(
  (status = 201, description = "Todo created", body = Book),
  ),
)]
pub async fn create_book(
    State(app_state): State<AppState>,
    Json(body): Json<NewBook>,
) -> impl IntoResponse {
    let db = &app_state.db;

    if let Err(errors) = body.validate() {
        return (StatusCode::BAD_REQUEST, Json(&errors)).into_response();
    }
    let response = create_item::<Book, NewBook>(db, &body).await;
    match response {
        Ok(Some(payload)) => {
            let doc: Book = from_document(payload).expect("error 5");
            // info!("created item: {:?}", doc.id);
            (StatusCode::CREATED, Json(&doc)).into_response()
        }
        Ok(None) => (StatusCode::NOT_FOUND, Json(&"No user found".to_string())).into_response(),
        Err(err) => (StatusCode::INTERNAL_SERVER_ERROR, Json(&err.to_string())).into_response(),
    }
}

/// Delete `Book` by ID
#[utoipa::path(
  delete,
  path = "/api/book/{id}",
  tag = Book::TAG,
  responses(
  (status = 200, description = "Book deleted", body = String),
  // (status = 404, description = "Book not found", body = HttpError),
  ),
)]
pub async fn delete_book(State(app_state): State<AppState>, id: Path<String>) -> impl IntoResponse {
    let item_id = id.0;
    let db = &app_state.db;
    let result = delete_by_id::<Book>(db, &item_id).await;
    match result {
        Ok(delete_result) => {
            if delete_result.deleted_count == 1 {
                (StatusCode::OK, Json(&"successfully deleted!")).into_response()
            } else {
                (
                    StatusCode::NOT_FOUND,
                    Json(&format!("item with specified ID {item_id} not found!")),
                )
                    .into_response()
            }
        }
        Err(_) => (
            StatusCode::NOT_FOUND,
            Json(&format!("item with specified ID {item_id} not found!")),
        )
            .into_response(),
    }
}

/// Delete all `Book`
#[utoipa::path(
  delete,
  path = "/api/book",
  tag = Book::TAG,
  responses(
  (status = 200, description = "Book deleted", body = String),
  ),
)]
pub async fn drop_books(State(app_state): State<AppState>) -> impl IntoResponse {
    let db = &app_state.db;
    drop_collection::<Book>(db).await.expect("das");
    tracing::debug!("dropped collection {}", Book::COLLECTION);
    (StatusCode::OK, Json(&"successfully deleted!")).into_response()
}

/// Update a `Book` by id and `UpdateBook` struct.
#[utoipa::path(
  put,
  path = "/api/book/{id}",
  tag = Book::TAG,
  request_body = UpdateBook,
  responses(
  (status = 200, description = "Book updated", body = Book),
  // (status = 404, description = "Book not found", body = HttpError),
  ),
)]
pub async fn update_book(
    Path(id): Path<String>,
    app_state: State<AppState>,
    Json(body): Json<UpdateBook>,
) -> impl IntoResponse {
    if let Err(error) = body.validate() {
        return (StatusCode::BAD_REQUEST, Json(error)).into_response();
    }
    let db = &app_state.db;
    let result = update_by_id::<Book, UpdateBook>(db, body, &id)
        .await
        .unwrap();
    match result {
        Some(payload) => {
            let doc: Book = from_document(payload).unwrap();
            (StatusCode::OK, Json(&doc)).into_response()
        }
        None => (
            StatusCode::NOT_FOUND,
            Json(&format!("not found item with ID {id}")),
        )
            .into_response(),
    }
}
