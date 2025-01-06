use influxdb2::api::buckets::ListBucketsRequest;
use influxdb2::models::{Bucket, Buckets, LabelResponse, PostBucketRequest, Query};
use influxdb2::{Client, FromMap, RequestError};
use std::collections::HashMap;
use std::sync::Arc;

#[derive(Clone)]
pub struct InfluxConfig {
    pub client: Client,
    pub org: String,
    pub bucket: String,
}

pub struct UpdateLabel {
    org_id: &'static str,
    name: &'static str,
    properties: Option<HashMap<String, String>>,
}

impl InfluxConfig {
    pub async fn list_buckets(
        &self,
        q: Option<ListBucketsRequest>,
    ) -> Result<Vec<Bucket>, RequestError> {
        let buckets = self.client.list_buckets(q).await?;
        Ok(buckets.buckets)
    }
    pub async fn create_bucket(&self, q: Option<PostBucketRequest>) -> Result<(), RequestError> {
        self.client.create_bucket(q).await?;
        Ok(())
    }
    pub async fn delete_bucket(&self, bucket_id: &str) -> Result<(), RequestError> {
        self.client.delete_bucket(bucket_id).await?;
        Ok(())
    }
    pub async fn create_label(&self, body: UpdateLabel) -> Result<LabelResponse, RequestError> {
        let label = self
            .client
            .create_label(body.org_id, body.name, body.properties)
            .await?;
        Ok(label)
    }
    pub async fn read<T: FromMap>(&self, query: Query) -> Result<Vec<T>, RequestError> {
        let s = self.client.query::<T>(Some(query)).await?;
        Ok(s)
    }
    pub async fn create(config: Arc<InfluxConfig>) {
        // client.write(&config.bucket)
    }
}

pub trait InfluxDBMethods<T: FromMap> {
    async fn create(client: &Client, config: Arc<InfluxConfig>) {
        // client.write(&config.bucket)
    }
    async fn read(client: &Client, query: Query) -> Result<Vec<T>, RequestError> {
        let s = client.query::<T>(Some(query)).await?;
        Ok(s)
    }
    async fn list_buckets(
        client: &Client,
        q: Option<ListBucketsRequest>,
    ) -> Result<Buckets, RequestError> {
        let buckets = client.list_buckets(q).await?;
        Ok(buckets)
    }
}
