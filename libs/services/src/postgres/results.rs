use axum::{
    extract::Json,
    http::StatusCode,
    response::{IntoResponse, Response},
};
use serde::Serialize;
use sqlx::postgres::PgQueryResult;
use sqlx::Error;
use std::fmt::Debug;
use tracing::{debug, error, info};

pub fn handle_result<T>(result: Result<T, Error>, success_status: StatusCode) -> Response
where
    T: Serialize + Debug,
{
    match result {
        Ok(payload) => {
            // info!("Data: {:?}", &payload);
            debug!("Data: {:?}", &payload);
            (success_status, Json(&payload)).into_response()
        }
        Err(e) => {
            error!("Error: {:?}", &e.to_string());
            (StatusCode::INTERNAL_SERVER_ERROR, Json(&e.to_string())).into_response()
        }
    }
}

pub fn handle_delete_result(result: Result<PgQueryResult, Error>, item_id: &str) -> Response {
    match result {
        Ok(payback) => {
            if payback.rows_affected() > 0 {
                info!("Deleted item with ID: {}", &item_id);
                (
                    StatusCode::OK,
                    Json(format!("Deleted item with ID: {}", item_id)),
                )
                    .into_response()
            } else {
                error!("Item with ID: {} not found", &item_id);
                (
                    StatusCode::NOT_FOUND,
                    Json(format!("Item with ID: {} not found", item_id)),
                )
                    .into_response()
            }
        }
        Err(e) => {
            error!("Error: {:?}", &e.to_string());
            (StatusCode::INTERNAL_SERVER_ERROR, Json(e.to_string())).into_response()
        }
    }
}

pub fn handle_drop_result(result: Result<PgQueryResult, Error>) -> Response {
    match result {
        Ok(payload) => {
            info!("Deleted all items: {:?}", &payload);
            (StatusCode::OK, Json("Deleted all items")).into_response()
        }
        Err(e) => {
            error!("Error: {:?}", &e.to_string());
            (StatusCode::INTERNAL_SERVER_ERROR, Json(e.to_string())).into_response()
        }
    }
}
