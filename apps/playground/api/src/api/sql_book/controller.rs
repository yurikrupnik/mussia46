use super::model::{Book, CreateBook, UpdateBook};
use crate::app_state::AppState;
use axum::{
  extract::{Json, Path, State},
  http::StatusCode,
  response::IntoResponse,
};
use log::{error, info};
use services::postgres::{
  results::{handle_delete_result, handle_drop_result, handle_result},
  service::{
    create_item, delete_by_id, drop_collection, get_by_id, get_list, update_by_id, SqlMethods,
  },
};
use uuid::Uuid;
use validator::Validate;

/// Get list of books.
///
/// List `Book`.
///
/// One could call the api endpoint with following curl.
/// ```text
/// curl localhost:8080/api/sql-book
/// ```
#[utoipa::path(
  get,
  path = "/api/sql-book",
  tag = "Sql-book",
  responses(
(status = 200, description = "Collection found successfully", body = [Book]),
    // (status = 400, description = "Api error", body = ErrorResponse),
    // (status = 500, description = "Internal error", body = ErrorResponse),
  ),
)]
pub async fn get_books(State(app_state): State<AppState>) -> impl IntoResponse {
  let query = "where title = 'ariss'";
  // let query = "where title = 'ariss'";
  // let result = get_list::<Book>(&app_state.pool, Some(query)).await;
  // let result = SqlService::get_list(&app_state.pool, Some(query)).await;
  let result = Book::get_list(&app_state.pool, &Some(query)).await;
  handle_result(result, StatusCode::OK)
}

/// Get Book by id.
///
/// Return found `Book` with status 200 or 404 not found if `Book` is not found from Postgres DB.
#[utoipa::path(
  get,
  path = "/api/sql-book/{id}",
  tag = "Sql-book",
  responses(
(status = 200, description = "Book found from db", body = Book),
    // (status = 404, description = "Book not found by id", body = ErrorResponse, example = json!(ErrorResponse::NotFound(String::from("id = 1"))))
  ),
  params(
("id", description = "Unique storage id of Book")
  )
)]
pub async fn get_book(
  Path(id): Path<String>,
  State(app_state): State<AppState>,
) -> impl IntoResponse {
  info!("Get book by id: {}", &id);
  // Parse the id as a UUID
  let item_id = match Uuid::parse_str(&id) {
    Ok(id) => id,
    Err(_) => return (StatusCode::BAD_REQUEST, "Invalid UUID format").into_response(),
  };
  // fetch the item from the database
  let result = get_by_id::<Book>(&app_state.pool, &item_id).await;
  // return the result of the query
  handle_result(result, StatusCode::OK)
}

/// Delete Book by given path variable id.
///
/// This ednpoint needs `api_key` authentication in order to call. Api key can be found from README.md.
///
/// Api will delete `Book` by the provided id and return success 200.
/// If storage does not contain `Book` with given id 404 not found will be returned.
#[utoipa::path(
  delete,
  path = "/api/sql-book/{id}",
  tag = "Sql-book",
  responses(
(status = 200, description = "Book deleted successfully"),
    // TODO add unauthorized response
    // (status = 401, description = "Unauthorized to delete Book", body = ErrorResponse, example = json!(ErrorResponse::Unauthorized(String::from("missing api key")))),
    // (status = 404, description = "Book not found by id", body = ErrorResponse, example = json!(ErrorResponse::NotFound(format!(
    // "not found id = {}",
    // 1
    // ))))
  ),
  params(
("id", description = "Unique id of Book")
  ),
  security(
("api_key" = [])
  )
)]
pub async fn delete_book(Path(id): Path<String>, app_state: State<AppState>) -> impl IntoResponse {
  // Parse the id as a UUID
  let item_id = match Uuid::parse_str(&id) {
    Ok(id) => id,
    Err(_) => return (StatusCode::BAD_REQUEST, "Invalid UUID format").into_response(),
  };
  let result = delete_by_id::<Book>(&app_state.pool, &item_id).await;
  handle_delete_result(result, &item_id.to_string())
}

/// Create new Book.
///
/// Post a new `Book` in request body as json to store it. Api will return
/// created `Book` on success.
///
/// One could call the api with following curl.
/// ```text
/// curl -X POST -H "Content-Type: application/json" -d '{"firstName": "Test name", "lastName": "Test last", "email": "a@a.com", "username": "test"}' localhost:8080/api/book
/// ```
#[utoipa::path(
post,
path = "/api/sql-book",
tag = "Sql-book",
request_body = CreateBook,
responses(
(status = 201, description = "Book created successfully", body = Book),
)
)]
pub async fn create_book(
  app_state: State<AppState>,
  Json(body): Json<CreateBook>,
) -> impl IntoResponse {
  if let Err(error) = body.validate() {
    return (StatusCode::BAD_REQUEST, Json(error)).into_response();
  }
  let result = create_item::<Book, CreateBook>(&app_state.pool, &body).await;
  handle_result(result, StatusCode::CREATED)
}

/// Drop Book collection.
///
/// Api will delete all `Book` and return success 200.
/// If storage does not contain `Book` with given id 404 not found will be returned.
#[utoipa::path(
  delete,
  path = "/api/sql-book",
  tag = "Sql-book",
  responses(
(status = 200, description = "Book deleted successfully"),
  ),
)]
pub async fn drop_books(app_state: State<AppState>) -> impl IntoResponse {
  let result = drop_collection::<Book>(&app_state.pool).await;
  handle_drop_result(result)
}

/// Update Book with given id.
///
/// This endpoint supports optional authentication.
///
/// Tries to update `Book` by given id as path variable. If todo is found by id values are
/// updated according `UpdateBook` and updated `Book` is returned with status 200.
/// If todo is not found then 404 not found is returned.
#[utoipa::path(
put,
path = "/api/sql-book/{id}",
tag = "Sql-book",
request_body = UpdateBook,
responses(
(status = 200, description = "Book updated successfully", body = Book),
// (status = 404, description = "Book not found by id", body = ErrorResponse, example = json!(ErrorResponse::NotFound(String::from("id = 1"))))
),
params(
("id", description = "Unique storage id of Book")
),
security(
(),
("api_key" = [])
)
)]
pub async fn update_book(
  app_state: State<AppState>,
  Path(id): Path<String>,
  Json(body): Json<UpdateBook>,
) -> impl IntoResponse {
  if let Err(error) = body.validate() {
    return (StatusCode::BAD_REQUEST, Json(error)).into_response();
  }

  // Parse the id as a UUID
  let item_id = match Uuid::parse_str(&id) {
    Ok(id) => id,
    Err(_) => return (StatusCode::BAD_REQUEST, "Invalid UUID format").into_response(),
  };

  let result = update_by_id::<Book, UpdateBook>(&app_state.pool, &item_id, &body).await;

  match result {
    Ok(payload) => {
      info!("Data: {:?}", &payload);
      (StatusCode::OK, Json(&payload)).into_response()
    }
    Err(sqlx::Error::ColumnNotFound(msg)) => {
      error!("ColumnNotFound: {:?}", &msg);
      (StatusCode::BAD_REQUEST, Json(msg)).into_response()
    }
    Err(e) => {
      error!("Error: {:?}", &e.to_string());
      (StatusCode::INTERNAL_SERVER_ERROR, Json(&e.to_string())).into_response()
    }
  }
}
