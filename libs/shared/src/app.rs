use crate::handlers::{health_check, not_found};
use axum::routing::get;
use axum::Router;
use utoipa::OpenApi;
use utoipa_rapidoc::RapiDoc;
use utoipa_redoc::{Redoc, Servable as RedocServable};
use utoipa_scalar::{Scalar, Servable as scalarServable};
use utoipa_swagger_ui::SwaggerUi;
use tower_http::trace::TraceLayer;

pub fn app<T, S: 'static + Clone + Send + Sync>(state: S, apis: Router<S>) -> Router
where
    T: OpenApi + 'static,
{
    Router::new()
        .merge(SwaggerUi::new("/swagger-ui").url("/api-docs/openapi.json", T::openapi()))
        .merge(Redoc::with_url("/redoc", T::openapi()))
        .merge(RapiDoc::new("/api-docs/openapi.json").path("/rapidoc"))
        .merge(Scalar::with_url("/scalar", T::openapi()))
        .layer(TraceLayer::new_for_http())
        .route("/health", get(health_check))
        // .layer(CookieManagerLayer::new())
        .nest("/api", apis)
        .with_state(state)
        .fallback(not_found)
}
