// #![deny(clippy::unwrap_used)]
// #![deny(clippy::expect_used)]
// // #![deny(clippy::clone)]
// #![deny(clippy::panic)]
// #![deny(unused_must_use)]
use api::routes;
use app_state::AppState;
use axum::response::IntoResponse;
use axum::routing::get;
use axum::Extension;
use shared::{app::app, shutdown::shutdown_signal};
use log::info;
use services::influx::services::InfluxConfig;
use services::{
  influx::connector::connect as influx_connect, mongo::connector::connect as mongo_connect,
  postgres::connector::connect as postgres_connect, redis::connector::connect as redis_connect,
};
use std::sync::{Arc, Mutex};
use swagger::ApiDoc;
use generals::{envs::Env, tracing::init_tracing};

mod api;
mod app_state;
// mod error;
mod swagger;
use shared::handlers::health_check;
use eyre::{eyre, OptionExt, Result};

#[tokio::main]
async fn main() -> Result<()> {
  // Initialize tracing (logging)
  init_tracing();
  tracing::info!("Initializing application");

  let dbs = tokio::join!(
        postgres_connect(None, None), // Connect to Postgres
        influx_connect(),             // Connect to InfluxDB
        mongo_connect("aris"),        // Connect to MongoDB
        redis_connect(),              // Setup Redis pool
    );

  let (postgres_pool_result, influx_client_result, db_result, redis_pool_result) = dbs;

  // Handle results of connections
  let influx_client = influx_client_result?;
  let db = db_result?;
  let redis_pool = redis_pool_result?;
  let postgres_pool = postgres_pool_result?;
  let redis_client = redis::Client::open("redis://localhost:6379")?;
  let redis_pub = redis_client.get_async_pubsub().await?;

  // migration
  // sqlx::migrate!().run(&postgres_pool).await?;

  // app state
  let org = "my-org".to_string();
  let bucket = "home".to_string();
  let config = Arc::new(InfluxConfig {
    client: influx_client,
    org,
    bucket,
  });
  let pubsub = Arc::new(Mutex::new(redis_pub));
  let state = AppState::new(db, redis_pool, postgres_pool, pubsub);

  let router = app::<ApiDoc, AppState>(state.clone(), routes()).layer(Extension(config));
  // run our app with hyper, listening globally on port
  let listener = tokio::net::TcpListener::bind(Env::get_url()).await?;

  info!("Server starting on {}", listener.local_addr()?);

  // Start the server.
  axum::serve(listener, router.into_make_service())
    .with_graceful_shutdown(shutdown_signal())
    .await
    .inspect_err(|e| {
      tracing::error!("Server encountered an error: {:?}", e);
      std::process::exit(1);
    })?;

  Ok(())
}
