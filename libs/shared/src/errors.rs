use axum::extract::rejection::JsonRejection;
use axum::http::request;
use axum::{
    http::StatusCode,
    response::{IntoResponse, Response},
};
use bb8::RunError;
use redis::RedisError;
use serde::Serialize;
use serde_json::Error;
use sqlx::Error as SqlxError;
use thiserror::Error;
use tracing::{error, info, warn};
use utoipa::ToSchema;
use uuid::Error as UuidError;
use validator::ValidationErrors;

#[derive(Debug, Error)]
pub enum AppError {
    // bb8::RunError<redis::RedisError>>>
    #[error("SerdeJson parsing error: {0}")]
    SerdeJson(#[from] serde_json::Error),
    #[error("RedisPool connection error: {0}")]
    RedisPool(#[from] RunError<RedisError>),
    #[error("InfluxDB connection error: {0}")]
    Influx(#[from] influxdb2::BuildError),
    #[error("InfluxDB request error: {0}")]
    RequestError(#[from] influxdb2::RequestError),

    #[error("MongoDB connection error: {0}")]
    Mongo(#[from] mongodb::error::Error),

    #[error("Redis error: {0}")]
    Redis(#[from] redis::RedisError),
    #[error("Redis error: {0}")]
    R2d2(#[from] r2d2::Error),

    #[error("Postgres connection error: {0}")]
    Postgres(#[from] sqlx::Error),

    #[error("Postgres migration error: {0}")]
    Migration(#[from] sqlx::migrate::MigrateError),

    #[error("I/O error: {0}")]
    Io(#[from] std::io::Error),

    #[error("JSON extraction error: {0}")]
    JsonExtractorRejection(#[from] JsonRejection),

    #[error("Validation error: {0}")]
    ValidationError(#[from] ValidationErrors),

    #[error("UUID error: {0}")]
    UuidError(#[from] UuidError),

    #[error("Not Found: {0}")]
    NotFound(String),
    #[error("Gateway Timeout")]
    GatewayTimeout,
    #[error("Database error: {0}")]
    DatabaseError(String),

    #[error("Internal server error")]
    InternalError,
    #[error("Internal server error")]
    AnyhowError(#[from] anyhow::Error),
    // #[error("Postgres connection error: {0}")]
    // PostgresConnect(#[from] Error),
}

impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        let (status, error_message, details, code) = match &self {
            AppError::SerdeJson(e) => {
                let error_code = 211;
                error!(error_code = error_code, "Serde json parsing error: {:?}", e);
                (
                    StatusCode::INTERNAL_SERVER_ERROR,
                    e.to_string(),
                    None,
                    error_code,
                )
            }
            AppError::R2d2(e) => {
                let error_code = 251;
                error!(error_code = error_code, "Serde json parsing error: {:?}", e);
                (
                    StatusCode::INTERNAL_SERVER_ERROR,
                    e.to_string(),
                    None,
                    error_code,
                )
            }
            AppError::RedisPool(e) => {
                let error_code = 111;
                error!(error_code = error_code, "Redis connection error: {:?}", e);
                (
                    StatusCode::INTERNAL_SERVER_ERROR,
                    e.to_string(),
                    None,
                    error_code,
                )
            }
            AppError::RequestError(e) => {
                let error_code = 121;
                error!(error_code = error_code, "RequestError error: {:?}", e);
                (StatusCode::BAD_GATEWAY, e.to_string(), None, error_code)
            }
            AppError::GatewayTimeout => {
                let error_code = 921;
                error!(error_code = error_code, "Gateway Timeout");
                (
                    StatusCode::GATEWAY_TIMEOUT,
                    "".to_string(),
                    None,
                    error_code,
                )
            }
            AppError::Influx(e) => {
                let error_code = 1;
                error!(
                    error_code = error_code,
                    "InfluxDB connection error: {:?}", e
                );
                (StatusCode::BAD_GATEWAY, e.to_string(), None, error_code)
            }
            AppError::Mongo(e) => {
                let error_code = 2;
                error!(error_code = 2, "MongoDB connection error: {:?}", e);
                (StatusCode::BAD_GATEWAY, e.to_string(), None, error_code)
            }
            AppError::Redis(e) => {
                let error_code = 3;
                error!(error_code = error_code, "Redis error: {:?}", e);
                (StatusCode::BAD_GATEWAY, e.to_string(), None, error_code)
            }
            AppError::Postgres(e) => map_sqlx_error(e),
            AppError::Migration(e) => {
                error!("Postgres migration error: {:?}", e);
                (StatusCode::INTERNAL_SERVER_ERROR, e.to_string(), None, 5)
            }
            AppError::Io(e) => {
                error!("I/O error: {:?}", e);
                (StatusCode::INTERNAL_SERVER_ERROR, e.to_string(), None, 6)
            }
            AppError::JsonExtractorRejection(e) => {
                warn!("JSON extraction error: {:?}", e);
                (e.status(), e.body_text(), None, 7)
            }
            AppError::ValidationError(e) => {
                info!("Validation error: {:?}", e);
                (
                    StatusCode::BAD_REQUEST,
                    "Validation failed for the provided input.".to_string(),
                    Some(serde_json::to_value(e).unwrap_or(serde_json::json!(null))),
                    8,
                )
            }
            AppError::UuidError(e) => {
                warn!("UUID error: {:?}", e);
                (StatusCode::BAD_REQUEST, "Invalid id".into(), None, 9)
            }
            AppError::NotFound(msg) => {
                info!("Not Found: {}", msg);
                (StatusCode::NOT_FOUND, msg.clone(), None, 10)
            }
            AppError::DatabaseError(msg) => {
                error!("Database error: {}", msg);
                (StatusCode::INTERNAL_SERVER_ERROR, msg.clone(), None, 11)
            }
            AppError::InternalError => (
                StatusCode::INTERNAL_SERVER_ERROR,
                "An unexpected error occurred.".into(),
                None,
                12,
            ),
            AppError::AnyhowError(a) => {
                (StatusCode::INTERNAL_SERVER_ERROR, a.to_string(), None, 99)
            }
        };

        let api_error = ApiErrorMessage::new(
            status,
            status.canonical_reason().unwrap_or("Error").to_string(),
            error_message,
            Some(details),
            Some(code),
        );
        // error!(api_error.to_);
        (status, axum::Json(api_error)).into_response()
    }
}

fn map_sqlx_error(error: &SqlxError) -> (StatusCode, String, Option<serde_json::Value>, i32) {
    match error {
        SqlxError::RowNotFound => {
            info!("Postgres row not found: {:?}", error);
            (
                StatusCode::NOT_FOUND,
                "Requested resource was not found.".into(),
                None,
                4,
            )
        }
        SqlxError::Configuration(e) => {
            error!("Postgres configuration error: {:?}", e);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Database configuration error.".into(),
                None,
                13,
            )
        }
        SqlxError::Database(e) => {
            error!("Postgres database error: {:?}", e);
            (
                StatusCode::BAD_GATEWAY,
                "A database error occurred.".into(),
                None,
                14,
            )
        }
        SqlxError::Io(e) => {
            error!("Postgres I/O error: {:?}", e);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Database I/O error.".into(),
                None,
                15,
            )
        }
        SqlxError::Tls(e) => {
            error!("Postgres TLS error: {:?}", e);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Database TLS error.".into(),
                None,
                16,
            )
        }
        SqlxError::Protocol(e) => {
            // error!("Postgres protocol error: {:?}", e);
            (
                StatusCode::BAD_GATEWAY,
                "Database protocol error.".into(),
                None,
                17,
            )
        }
        SqlxError::TypeNotFound { type_name } => {
            error!("Postgres type not found: type_name={}", type_name);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Database type not found.".into(),
                None,
                19,
            )
        }
        SqlxError::ColumnIndexOutOfBounds { index, len } => {
            error!(
                "Postgres column index out of bounds: index={}, len={}",
                index, len
            );
            (
                StatusCode::BAD_REQUEST,
                "Column index out of bounds.".into(),
                None,
                20,
            )
        }
        SqlxError::ColumnNotFound(column) => {
            error!("Postgres column not found: {}", column);
            (
                StatusCode::BAD_REQUEST,
                format!("Column '{}' not found in the result set.", column),
                None,
                21,
            )
        }
        SqlxError::Decode(e) => {
            warn!("Postgres decode error: {:?}", e);
            (
                StatusCode::BAD_REQUEST,
                "Failed to decode database response.".into(),
                None,
                22,
            )
        }
        SqlxError::Encode(e) => {
            warn!("Postgres encode error: {:?}", e);
            (
                StatusCode::BAD_REQUEST,
                "Failed to encode database request.".into(),
                None,
                23,
            )
        }
        SqlxError::AnyDriverError(e) => {
            error!("Postgres driver error: {:?}", e);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "A database driver error occurred.".into(),
                None,
                24,
            )
        }
        SqlxError::PoolTimedOut => {
            // warn!("Postgres connection pool timed out.");
            (
                StatusCode::SERVICE_UNAVAILABLE,
                "Database connection pool timed out.".into(),
                None,
                25,
            )
        }
        SqlxError::PoolClosed => {
            error!("Postgres connection pool has been closed.");
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Database connection pool closed.".into(),
                None,
                26,
            )
        }
        SqlxError::WorkerCrashed => {
            error!("Postgres connection pool worker crashed.");
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Database connection pool worker crashed.".into(),
                None,
                27,
            )
        }
        SqlxError::Migrate(e) => {
            error!("Postgres migration error: {:?}", e);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "Database migration error.".into(),
                None,
                28,
            )
        }
        _ => {
            // error!("Unhandled Postgres error: {:?}", error);
            (
                StatusCode::INTERNAL_SERVER_ERROR,
                "A database error occurred.".into(),
                None,
                29,
            )
        }
    }
}

#[derive(Debug, Serialize, ToSchema)]
pub struct ApiErrorMessage {
    /// HTTP status code
    pub status: u16,
    /// Short error type or title
    pub error: String,
    /// Detailed human-readable message
    pub message: String,
    /// Optional field for additional info
    #[serde(skip_serializing_if = "Option::is_none")]
    pub details: Option<serde_json::Value>,
    /// Custom error code
    #[serde(skip_serializing_if = "Option::is_none")]
    pub code: Option<i32>,
}

impl ApiErrorMessage {
    pub fn new(
        status: StatusCode,
        error: impl Into<String>,
        message: impl Into<String>,
        details: Option<impl serde::Serialize>,
        code: Option<i32>,
    ) -> Self {
        Self {
            status: status.as_u16(),
            error: error.into(),
            message: message.into(),
            details: details.map(|d| serde_json::to_value(d).unwrap_or(serde_json::json!(null))),
            code,
        }
    }

    // Optional: Add convenience constructors
    pub fn from_status(status: StatusCode, message: impl Into<String>) -> Self {
        Self::new(
            status,
            status.canonical_reason().unwrap_or("Error"),
            message,
            None::<serde_json::Value>,
            None,
        )
    }
}

#[derive(Debug, Serialize, thiserror::Error)]
#[serde(tag = "result", rename_all = "lowercase")]
pub enum ApiResponse<T> {
    Ok {
        /// On success, we have a `data` field of generic type `T`.
        data: T,
    },
    Error {
        /// On error, we flatten the `ApiErrorMessage` into this variant’s fields.
        #[serde(flatten)]
        error: ApiErrorMessage,
    },
}

// return ApiResponse::Error { error: ApiErrorMessage::not_found("Task not found") }
//
impl ApiErrorMessage {
    pub fn not_found(message: impl Into<String>) -> Self {
        ApiErrorMessage {
            status: StatusCode::NOT_FOUND.as_u16(), // 404
            error: "Not Found".to_string(),
            message: message.into(),
            details: None,
            code: None,
        }
    }

    pub fn bad_request(message: impl Into<String>) -> Self {
        ApiErrorMessage {
            status: StatusCode::BAD_REQUEST.as_u16(), // 400
            error: "Bad Request".to_string(),
            message: message.into(),
            details: None,
            code: None,
        }
    }

    // etc.
}
