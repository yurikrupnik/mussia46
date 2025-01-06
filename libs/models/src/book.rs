use mongodb::bson::{doc, oid::ObjectId};
use proc_macros::DbResource;
use serde::{Deserialize, Serialize};
use serde_json::json;
// use services::mongo::{
//     query_param_processing::QueryParamProcessing, serialize::serialize_option_object_id,
// };
// use se
use sqlx::FromRow;
use ts_rs::TS;
use utoipa::{IntoParams, ToSchema};
use validator::Validate;

/// Book struct
#[derive(
    Clone, FromRow, ToSchema, Debug, PartialEq, Eq, Deserialize, Serialize, DbResource, TS,
)]
#[schema(example = json!({"id": "6646396301dcad222bba63b3", "title": "Title 1", "pages": 120}))]
#[ts(export)]
pub struct Book {
    /// Book id
    #[serde(
        rename(deserialize = "_id"),
        serialize_with = "serialize_option_object_id"
    )]
    #[ts(type = "string")]
    #[schema(
        value_type = String,
        example = "6646396301dcad222bba63b4"
  )]
    #[serde(skip_serializing_if = "Option::is_none")]
    pub id: Option<ObjectId>,
    /// Title of the book
    #[serde(skip_serializing_if = "Option::is_none")]
    title: Option<String>,
    /// Amount of pages in a book
    #[serde(skip_serializing_if = "Option::is_none")]
    pages: Option<u16>,
}

/// NewTodo is used to create a new `Todo`
#[derive(Debug, Deserialize, Serialize, Validate, Clone, ToSchema, TS)]
#[schema(example = json!({"title": "Title 1", "pages": 120}))]
#[ts(export)]
pub struct NewBook {
    #[validate(length(min = 2))]
    title: String,
    #[validate(range(min = 2, max = 2000))]
    pages: u16,
}

/// UpdateBook is used to update a `Book`
#[derive(Debug, Deserialize, Serialize, Validate, Clone, ToSchema, TS)]
#[schema(example = json!({"completed": true}))]
#[ts(export)]
pub struct UpdateBook {
    #[validate(length(min = 2))]
    #[serde(skip_serializing_if = "Option::is_none")]
    title: Option<String>,
    #[validate(range(min = 2, max = 2000))]
    #[serde(skip_serializing_if = "Option::is_none")]
    pages: Option<u16>,
}
#[derive(Clone, Deserialize, Serialize, Debug, IntoParams, TS)]
// #[serde(deny_unknown_fields)]
#[ts(export)]
pub struct BookListQuery {
    // #[serde(skip_serializing_if = "Option::is_none")]
    // pages: Option<u16>,
    #[serde(skip_serializing_if = "Option::is_none")]
    title: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub limit: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub total: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub skip: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub projection: Option<String>,
}

#[derive(Clone, Deserialize, Serialize, Debug, IntoParams, TS)]
#[serde(deny_unknown_fields)]
#[ts(export)]
pub struct BookItemQuery {
    #[serde(skip_serializing_if = "Option::is_none")]
    completed: Option<bool>,
    #[serde(skip_serializing_if = "Option::is_none")]
    text: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub projection: Option<String>,
}

// impl QueryParamProcessing for BookListQuery {
//     fn get_limit(&self) -> Option<String> {
//         self.limit.clone()
//     }
//
//     fn clear_limit(&mut self) {
//         self.limit = None;
//     }
//
//     fn get_projection(&self) -> Option<String> {
//         self.projection.clone()
//     }
//
//     fn clear_projection(&mut self) {
//         self.projection = None;
//     }
//
//     fn into_inner(self) -> serde_json::Value {
//         serde_json::to_value(self).unwrap_or_else(|_| json!({}))
//     }
// }
