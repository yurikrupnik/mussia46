use crate::handlers::{health_check, not_found};
use axum::routing::get;
use axum::Router;
use utoipa::OpenApi;

pub fn app<T, S: 'static + Clone + Send + Sync>(state: S, apis: Router<S>) -> Router
where
    T: OpenApi + 'static,
{
    Router::new()
        // .merge(SwaggerUi::new("/swagger-ui").url("/api-docs/openapi.json", T::openapi()))
        // .merge(Redoc::with_url("/redoc", T::openapi()))
        // .merge(RapiDoc::new("/api-docs/openapi.json").path("/rapidoc"))
        // .merge(Scalar::with_url("/scalar", T::openapi()))
        .route("/health", get(health_check))
        // .layer(CookieManagerLayer::new())
        .nest("/api", apis)
        .with_state(state)
        .fallback(not_found)
}
