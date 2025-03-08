use super::model::{CpuLoadShort, GetCpuLoadShort, PositionRecord, PositionRecordDTO, Types};
// use std::any::Any;
// use anyhow::__private::kind::TraitKind;
use axum::{
    extract::{Extension, Query as AxumQuery},
    response::{IntoResponse, Response, Result as AxumResult},
    Json,
};
use chrono::{DateTime, Duration, Utc};
use futures::prelude::*;
use http::StatusCode;
use influxdb2::api::buckets::ListBucketsRequest;
use influxdb2::models::{Bucket, Buckets, DataPoint, PostBucketRequest, Query};
use influxdb2::RequestError;
use log::{log, trace};
use serde::{Deserialize, Serialize};
use services::influx::services::InfluxConfig;
use std::sync::Arc;
use utoipa::{IntoParams, ToSchema};

#[derive(thiserror::Error, Debug)]
pub enum MyError {
    #[error("Database error: {0}")]
    Sql(#[from] sqlx::Error),
    // #[error(transparent)]
    #[error("Influx error: {0}")]
    InfluxDB(#[from] RequestError),
    #[error("Custom error")]
    Custom,
    // #[error("Database error: {0}")]
    // RequestError(String),
}
use tracing::error;
impl IntoResponse for MyError {
    fn into_response(self) -> Response {
        let (status, message) = match self {
            MyError::Sql(e) => (axum::http::StatusCode::BAD_REQUEST, e.to_string()),
            MyError::InfluxDB(e) => {
                // log::error!("influx db error: {e:?}");
                // (axum::http::StatusCode::UNAUTHORIZED, e.to_string())
                // Match on the different possible RequestError variants
                match e {
                    // This variant includes a status code (reqwest::StatusCode) returned from InfluxDB
                    RequestError::Http { status, text } => {
                        // log::error!("{text:?}");
                        error!(name: "invalid_input influx db", "Invalid input influx db: {}", text);
                        // Convert `reqwest::StatusCode` to `axum::http::StatusCode`
                        (StatusCode::INTERNAL_SERVER_ERROR, text)
                        // let axum_status = StatusCode::from_u16(status.as_u16())
                        //     .unwrap_or(StatusCode::INTERNAL_SERVER_ERROR);
                        // (axum_status, text)
                    }

                    // For other variants, you can choose a default or handle them individually
                    RequestError::ReqwestProcessing { source } => {
                        (StatusCode::INTERNAL_SERVER_ERROR, source.to_string())
                    }
                    RequestError::Serializing { source } => {
                        (StatusCode::INTERNAL_SERVER_ERROR, source.to_string())
                    }
                    RequestError::Deserializing { text } => {
                        (StatusCode::INTERNAL_SERVER_ERROR, text)
                    } // etc. (Add more arms as needed for other variants)
                }
            }
            MyError::Custom => (axum::http::StatusCode::BAD_REQUEST, "shit".into()),
            // MyError::SomethingElseWentWrong => "something else went wrong",
            // MyError::RequestError(a) => "influx error",
        };
        (status, message).into_response()
        // it's often easiest to implement `IntoResponse` by calling other implementations
        // (StatusCode::INTERNAL_SERVER_ERROR, body).into_response()
    }
}

/// A wrapper around the 3rd-party `Bucket` struct
#[derive(Debug, Serialize, ToSchema)]
#[serde(rename_all = "camelCase")]
pub struct BucketWrapper {
    pub id: Option<String>,
    // #[serde(rename = "orgID", skip_serializing_if = "Option::is_none")]
    pub org_id: Option<String>,
    pub name: Option<String>,
    pub description: Option<String>,
    pub retention_rules: Vec<RetentionRule>,
}

/// If `Bucket` also has a `RetentionRule` type from influxdb2,
/// you might need a wrapper for that as well.
#[derive(Debug, Serialize, ToSchema)]
#[serde(rename_all = "camelCase")]
pub struct RetentionRule {
    pub every_seconds: i32,
    pub shard_group_duration_seconds: Option<i64>,
    // ...
}

// Then provide a conversion from the third-party `Bucket` into your wrapper.
impl From<Bucket> for BucketWrapper {
    fn from(bucket: Bucket) -> Self {
        BucketWrapper {
            id: bucket.id,
            org_id: bucket.org_id,
            name: Some(bucket.name),
            description: bucket.description,
            retention_rules: bucket
                .retention_rules
                .into_iter()
                .map(|rule| RetentionRule {
                    every_seconds: rule.every_seconds,
                    shard_group_duration_seconds: rule.shard_group_duration_seconds,
                })
                .collect(),
        }
    }
}

#[utoipa::path(
  get,
  path = "/api/db/bucket",
  tag = "Buckets",
  responses(
    // (status = 200, description = "Collection found successfully", body = [BucketWrapper]),
    // (status = 400, description = "Api error", body = MyError),
    // (status = 500, description = "Internal error", body = ErrorResponse),
  ),
)]
pub async fn read_buckets(
    Extension(config): Extension<Arc<InfluxConfig>>,
    AxumQuery(params): AxumQuery<ListBucketsRequest>,
) -> Result<Json<Vec<BucketWrapper>>, MyError> {
    let buckets = config.list_buckets(Some(params)).await?;
    // Convert each influxdb2::models::Bucket into BucketWrapper
    let bucket_wrappers = buckets
        .into_iter()
        .map(BucketWrapper::from)
        .collect::<Vec<_>>();
    Ok(Json(bucket_wrappers))
}

pub async fn create_bucket(
    Extension(config): Extension<Arc<InfluxConfig>>,
    Json(params): Json<PostBucketRequest>,
) -> Result<axum::http::StatusCode, MyError> {
    config.create_bucket(Some(params)).await?;
    Ok(axum::http::StatusCode::CREATED)
}

#[derive(Clone, Deserialize, Serialize, Debug, IntoParams)]
struct DeleteBucket {
    /// Bucket Id
    id: String,
}

#[utoipa::path(
  delete,
  path = "/api/db/bucket/:id",
  tag = "Buckets",
  params(DeleteBucket),
  responses(
    (status = 200, description = "Collection found successfully", body = [BucketWrapper]),
    // (status = 400, description = "Api error", body = MyError),
    // (status = 500, description = "Internal error", body = ErrorResponse),
  ),
)]
pub async fn delete_bucket(
    Extension(config): Extension<Arc<InfluxConfig>>,
    id: axum::extract::Path<String>,
) -> Result<axum::http::StatusCode, MyError> {
    config.delete_bucket(id.as_str()).await?;
    Ok(axum::http::StatusCode::OK)
}

pub async fn generate(
    Extension(config): Extension<Arc<InfluxConfig>>,
    AxumQuery(params): AxumQuery<Params>,
) -> impl IntoResponse {
    // InfluxConfig::li
    // let c = config.client.clone();
    // let s = InfluxConfig {
    //     client: c,
    //     org: "das".to_owned(),
    //     bucket: "Dsa".into(),
    // };
    // s.li
    // let now = Utc::now();
    // let one_year_ago = now - Duration::days(180);
    // let count = 5_000;
    // let start_lat = 37.7749;
    // let start_lon = -122.4194;
    // let interval_seconds = 1;
    // let max_drift = 0.00001;
    // let points_a = generate_geoposition_data(
    //     count,
    //     one_year_ago,
    //     interval_seconds,
    //     start_lat,
    //     start_lon,
    //     max_drift,
    // );
    // let points_a = generate_data_points("cpu_usage", one_year_ago, now);
}

/// Handler to write a data point to InfluxDB 2
pub async fn write_data(Extension(config): Extension<Arc<InfluxConfig>>) -> Result<(), String> {
    // let points = vec![
    //     CpuLoadShort {
    //         host: Some("server01".to_owned()),
    //         region: Some("us-west".to_owned()),
    //         value: 0.2,
    //         time: Utc::now().timestamp_nanos_opt().expect("failed time"),
    //     },
    //     CpuLoadShort {
    //         host: Some("server04".to_owned()),
    //         region: None,
    //         value: 0.1,
    //         time: Utc::now().timestamp_nanos_opt().expect("failed time"),
    //     },
    // ];

    let now = Utc::now().timestamp();
    let start_time = (now - Duration::days(3).num_seconds()).to_string(); // 2 days ago
    let end_time = (now + Duration::days(2).num_seconds()).to_string(); // 3 days ahead
    let position_records = vec![PositionRecord {
        latitude: Some(12.312312),
        longitude: Some(12.234345),
        time: Utc::now().timestamp_nanos_opt().expect("das"),
        sensor_id: "12546".to_string(),
        drone_id: "23456".to_string(),
        start_time,
        end_time,
        flight_type: Types::Contingent.to_string(),
    }];

    config
        .client
        .write(&config.bucket, stream::iter(position_records))
        .await
        .expect("TODO: panic message");
    println!("Data successfully written to langs");
    Ok(())
}

#[derive(serde::Deserialize)]
pub struct Params {
    measurement: Option<String>,
}

// Handler to read data from InfluxDB 2
pub async fn read_data(
    AxumQuery(params): AxumQuery<Params>,
    Extension(config): Extension<Arc<InfluxConfig>>,
) -> impl IntoResponse {
    // let measurement = "long_lang".to_string();
    let measurement = params.measurement;
    // let measurement = params
    //     .measurement
    //     .unwrap_or_else(|| "cpu_load_short".to_string());
    let qs = format!(
        r#"
from(bucket: "home")
  |> range(start: -1w)
  |> filter(fn: (r) => r.end_time >= "{}")
"#,
        Utc::now().timestamp()
    );
    //     let qs = format!(
    //         r#"
    // from(bucket: "home")
    //   |> range(start: -1w)
    //   |> filter(fn: (r) => r._measurement == "long_lang")
    //  // |> filter(fn: (r) => r._measurement == "long_lang" and r.end_time >= 1733089384 and r.end_time <= 1735249384)
    //   // |> filter(fn: (r) => r._measurement == {})
    //   // |> filter(fn: (r) => r._measurement == "cpu_load_short" and r.host == "server01")
    //   // |> sort(columns: ["_time"], desc: false)
    // "#,
    //         measurement
    //     );
    let query = Query::new(qs);

    let res: Vec<PositionRecordDTO> = config
        .client
        .query::<PositionRecordDTO>(Some(query))
        .await
        .expect("Unable to query data");
    println!("len: {}", res.len());
    Json(res)
}

// use axum_utils::config;
use serde_json::json;
use tower::layer::util::Stack;
use tracing::field::AsField;
use ts_rs::TS;

pub async fn delete() -> impl IntoResponse {
    // let params = [("org", "bar"), ("bucket", "quux")];
    // let client = reqwest::Client::new();
    // let res = client
    //     .post("http://localhost:8086/api/v2/delete")
    //     // .form(&params)
    //     .send()
    //     .await
    //     .expect("faked");
    // Json(res)
    Json(json!({"status": "success"}))
}
