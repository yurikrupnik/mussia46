use mongodb::bson::{doc, oid::ObjectId};
use proc_macros::{DbResource, Reflective};
use serde::{Deserialize, Serialize};
use serde_json::json;
use services::mongo::{
    query_param_processing::QueryParamProcessing,
    serialize::{serialize_object_id, serialize_option_object_id},
};
use ts_rs::TS;
use utoipa::{IntoParams, ToSchema};
use validator::Validate;

/// Todo struct
#[derive(
    Default, Clone, ToSchema, PartialEq, Debug, Eq, Deserialize, Serialize, DbResource, TS,
)]
#[schema(example = json!({"id": "6646396301dcad222bba63b3", "text": "Buy food", "completed": false}))]
#[ts(export)]
pub struct Todo {
    /// Todo id
    #[serde(
        rename(deserialize = "_id"),
        serialize_with = "serialize_option_object_id"
    )]
    #[ts(type = "string")]
    #[schema(
        value_type = String,
        example = "6646396301dcad222bba63b3"
  )]
    #[serde(skip_serializing_if = "Option::is_none")]
    pub id: Option<ObjectId>,
    /// Todo text
    #[serde(skip_serializing_if = "Option::is_none")]
    text: Option<String>,
    /// Todo state
    #[serde(skip_serializing_if = "Option::is_none")]
    completed: Option<bool>,
}

impl Todo {
    const URL: &'static str = "shit";
}

/// NewTodo is used to create a new `Todo`
#[derive(Debug, Deserialize, Serialize, Validate, Clone, ToSchema, TS)]
#[schema(example = json!({"text": "Buy food"}))]
#[ts(export)]
pub struct NewTodo {
    /// Todo text
    #[validate(length(min = 2))]
    text: String,
    /// Todo state
    #[serde(default)]
    completed: bool,
}

/// UpdateTodo is used to update a `Todo`
#[derive(Debug, Deserialize, Serialize, Validate, Clone, ToSchema, TS)]
#[schema(example = json!({"completed": true}))]
#[ts(export)]
pub struct Update {
    #[validate(length(min = 2))]
    #[serde(skip_serializing_if = "Option::is_none")]
    text: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    completed: Option<bool>,
}
#[derive(Clone, Deserialize, Serialize, Debug, IntoParams, TS)]
#[serde(deny_unknown_fields)]
#[ts(export)]
pub struct TodoListQuery {
    #[serde(skip_serializing_if = "Option::is_none")]
    completed: Option<bool>,
    #[serde(skip_serializing_if = "Option::is_none")]
    text: Option<String>,
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
pub struct TodoItemQuery {
    #[serde(skip_serializing_if = "Option::is_none")]
    completed: Option<bool>,
    #[serde(skip_serializing_if = "Option::is_none")]
    text: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub projection: Option<String>,
}

impl QueryParamProcessing for TodoListQuery {
    fn get_limit(&self) -> Option<String> {
        self.limit.clone()
    }

    fn clear_limit(&mut self) {
        self.limit = None;
    }

    fn get_projection(&self) -> Option<String> {
        self.projection.clone()
    }

    fn clear_projection(&mut self) {
        self.projection = None;
    }

    fn into_inner(self) -> serde_json::Value {
        serde_json::to_value(self).unwrap_or_else(|_| json!({}))
    }
}
