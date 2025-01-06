use axum::{http::StatusCode, response::IntoResponse};

/// Utility function for mapping a `404 Not Found` response.
pub async fn not_found() -> impl IntoResponse {
    (StatusCode::NOT_FOUND, "404 Not Found")
}

/// Health check handler.
pub async fn health_check() -> impl IntoResponse {
    (StatusCode::OK, "healthy")
}

/// Utility function for mapping any error into a `500 Internal Server Error` response.
pub fn internal_error<E>(err: E) -> (StatusCode, String)
where
    E: std::error::Error,
{
    (StatusCode::INTERNAL_SERVER_ERROR, err.to_string())
}
