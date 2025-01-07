use fake::faker::company::en::Buzzword;
use fake::faker::finance::en::Bic;
use fake::Dummy;
use proc_macros::DbResource;
use serde::{Deserialize, Serialize};
use services::postgres::service::SqlMethods;
use sqlx::postgres::PgRow;
use sqlx::{FromRow, Row};
use utoipa::ToSchema;
use uuid::Uuid;
use validator::Validate;

#[derive(DbResource, ToSchema, Deserialize, Serialize, Debug)]
pub struct Book {
  pub id: Uuid,
  #[serde(skip_serializing_if = "Option::is_none")]
  pub title: Option<String>,
  #[serde(skip_serializing_if = "Option::is_none")]
  pub author: Option<String>,
  #[serde(skip_serializing_if = "Option::is_none")]
  pub description: Option<String>,
  #[serde(skip_serializing_if = "Option::is_none")]
  pub is_published: Option<bool>,
  #[serde(skip_serializing_if = "Option::is_none")]
  pub copies_sold: Option<i32>,
}

impl SqlMethods<Book, CreateBook, UpdateBook> for Book {
  // async fn get_list(pool: &PgPool, query: Option<&str>) -> sqlx::Result<Vec<Book>> {
  //     Ok(vec![Book {
  //         id: Uuid::new_v4(),
  //         title: Some("ds".to_string()),
  //         author: Some("ds".to_string()),
  //         description: Some("ds".to_string()),
  //         is_published: Some(false),
  //         copies_sold: Some(12),
  //     }])
  // }
}

impl<'r> FromRow<'r, PgRow> for Book {
  fn from_row(row: &PgRow) -> Result<Self, sqlx::Error> {
    Ok(Book {
      id: row.try_get("id")?,
      title: row.try_get("title").ok(),
      author: row.try_get("author").ok(),
      description: row.try_get("description").ok(),
      is_published: row.try_get("is_published").ok(),
      copies_sold: row.try_get("copies_sold").ok(),
    })
  }
}

#[derive(DbResource, ToSchema, Deserialize, Serialize, Validate, Debug, Clone, Dummy)]
pub struct CreateBook {
  #[validate(length(min = 2))]
  #[dummy(faker = "Buzzword()")]
  pub title: String,
  #[validate(length(min = 2))]
  #[dummy(faker = "Bic()")]
  pub author: String,
  #[validate(length(min = 2))]
  pub description: String,
  #[serde(default)]
  pub is_published: bool,
  #[validate(range(min = 0))]
  #[serde(default)]
  #[dummy(faker = "100..200")]
  pub copies_sold: i64,
}

#[derive(DbResource, ToSchema, Deserialize, Serialize, Validate, Debug, Clone)]
pub struct UpdateBook {
  #[validate(length(min = 2))]
  pub title: Option<String>,
  #[validate(length(min = 2))]
  pub author: Option<String>,
  #[validate(length(min = 2))]
  pub description: Option<String>,
  // testing those
  pub is_published: Option<bool>,
  pub copies_sold: Option<i64>,
}

impl Book {
  // pub const URL: &'static str = "/api/sql-book";
  // pub const COLLECTION: &'static str = "books";
  // pub const TAG: &'static str = "Books";
}
