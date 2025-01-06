use influxdb2::{api::buckets::ListBucketsRequest, Client, RequestError};
use std::env;

pub async fn connect() -> Result<Client, RequestError> {
    tracing::info!("Attempting to connect to InfluxDB");
    let org = env::var("INFLUXDB_ORG_ID").expect("INFLUXDB_ORG_ID must be set");
    let influx_client = Client::new(
        env::var("INFLUXDB_URL").expect("INFLUXDB_URL must be set"),
        &org,
        env::var("INFLUXDB_TOKEN").expect("INFLUXDB_TOKEN must be set"),
    );

    // Perform the combined test
    if let Err(e) = test_connection(&influx_client, org).await {
        tracing::error!("Failed to connect and verify InfluxDB: {}", e);
        std::process::exit(1);
    } else {
        tracing::info!("Successfully connected and verified InfluxDB");
    }

    Ok(influx_client)
}

async fn test_connection(client: &Client, org: String) -> Result<(), RequestError> {
    client.health().await?;

    let query = ListBucketsRequest {
        org: Some(org),
        ..ListBucketsRequest::default()
    };
    client.list_buckets(Some(query)).await?;

    Ok(())
}
