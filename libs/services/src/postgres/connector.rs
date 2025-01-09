use generals::envs::Env;
use sqlx::{postgres::PgPoolOptions, Pool, Postgres};

fn get_sql_uri() -> String {
  Env::get_postgres().unwrap()
}
pub async fn connect(
    url: Option<&str>,
    connections: Option<u32>,
) -> Result<Pool<Postgres>, sqlx::Error> {
    let max_connections = connections.unwrap_or(5);

    tracing::info!("Attempting to connect to Postgres");

    let pool = PgPoolOptions::new()
        .max_connections(max_connections)
        .connect(url.unwrap_or(&get_sql_uri()))
        .await
        .inspect(|_| tracing::info!("Successfully connected to Postgres"))
        .inspect_err(|e| {
            tracing::error!("Failed to connect to Postgres, error: {}", e.to_string());
            std::process::exit(1);
        })?;

    Ok(pool)
}

// #[cfg(test)]
// mod tests {
//     use super::*;
//     #[tokio::test]
//     async fn test_connect_with_invalid_url() {
//         let invalid_url = "invalid_url";
//
//         let result = connect(Some(invalid_url), None).await;
//
//         assert!(
//             result.is_err(),
//             "Connection with an invalid URL should fail."
//         );
//     }
// }
