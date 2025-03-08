use chrono::{DateTime, FixedOffset};
use influxdb2_derive::{FromDataPoint, WriteDataPoint};
use serde::{Deserialize, Serialize};
use strum_macros::{Display, EnumString};
// testing from-into - taking ownership
// pub struct YouTubeVideo {
//     title: String,
//     description: String,
// }
//
// impl AsRef<YouTubeVideo> for YouTubeVideo {
//     fn as_ref(&self) -> &Self {
//         self
//     }
// }
//
// impl AsMut<YouTubeVideo> for YouTubeVideo {
//     fn as_mut(&mut self) -> &mut YouTubeVideo {
//         self
//     }
// }
// impl YouTubeVideo {
//     pub fn new<T: Into<String>>(title: T, description: T) -> Self {
//         Self {
//             title: title.into(),
//             description: description.into(),
//         }
//     }
// }
//
// // testing asRef - borrowing
// fn asd() {
//     let mut vide = YouTubeVideo::new("asd", "dsds");
//     // let refd = vide.as_ref();
//     let srefd = vide.as_mut();
// }

#[derive(Serialize, Deserialize)]
pub struct DataPoint {
    pub measurement: String,
    pub field: String,
    pub value: f64,
}

#[derive(Default, Debug, Display, EnumString, Serialize)]
pub enum Types {
    #[default]
    #[strum(serialize = "Submitted")]
    Submitted,
    #[strum(serialize = "Approved")]
    Approved,
    #[strum(serialize = "Rejected")]
    Rejected,
    #[strum(serialize = "Ended")]
    Ended,
    #[strum(serialize = "Contingent")]
    Contingent,
    #[strum(serialize = "Nonconforming")]
    Nonconforming,
    #[strum(serialize = "Withdrawn")]
    Withdrawn,
    #[strum(serialize = "Activated")]
    Activated,
    #[strum(serialize = "Accepted")]
    Accepted,
    #[strum(serialize = "Canceled")]
    Canceled,
}
// mock data
/// A record representing a geospatial position with a timestamp.
#[derive(Default, Debug, WriteDataPoint, Serialize)]
#[measurement = "long_lang"]
pub struct PositionRecord {
    #[influxdb(field)]
    pub flight_type: String,
    #[influxdb(tag)]
    pub sensor_id: String,
    #[influxdb(tag)]
    pub drone_id: String,
    #[influxdb(field)]
    pub latitude: Option<f64>,
    // pub latitude: f64,
    #[influxdb(field)]
    pub longitude: Option<f64>,
    // pub longitude: f64,
    #[influxdb(timestamp)]
    pub time: i64,
    #[influxdb(tag)] // Use field for high cardinality
    pub start_time: String,
    #[influxdb(tag)] // Use field for high cardinality
    pub end_time: String,
}

#[derive(Debug, FromDataPoint, Default, Serialize)]
pub struct PositionRecordDTO {
    pub sensor_id: String,
    pub drone_id: String,
    pub time: DateTime<FixedOffset>,
    pub latitude: f64,
    pub longitude: f64,
    pub start_time: String,
    pub end_time: String,
}

#[derive(Default, WriteDataPoint, Debug)]
#[measurement = "cpu_load_short"]
pub struct CpuLoadShort {
    #[influxdb(tag)]
    pub host: Option<String>,
    #[influxdb(tag)]
    pub region: Option<String>,
    #[influxdb(field)]
    pub value: f64,
    #[influxdb(timestamp)]
    pub time: i64,
}

#[derive(Debug, FromDataPoint, Default, Serialize)]
pub struct GetCpuLoadShort {
    host: String,
    region: String,
    value: f64,
    time: DateTime<FixedOffset>,
}

// pub fn generate_geoposition_data(
//     count: usize,
//     start_time: DateTime<Utc>,
//     interval_seconds: i64,
//     start_lat: f64,
//     start_lon: f64,
//     max_drift: f64,
// ) -> Vec<PositionRecord> {
//     let mut rng = rand::thread_rng();
//     let mut current_lat = start_lat;
//     let mut current_lon = start_lon;
//
//     (0..count)
//         .map(|i| {
//             let ts = start_time + Duration::seconds(i as i64 * interval_seconds);
//
//             // Drift the position randomly within ±max_drift
//             current_lat += rng.gen_range(-max_drift..max_drift);
//             current_lon += rng.gen_range(-max_drift..max_drift);
//
//             PositionRecord {
//                 timestamp: ts.timestamp(),           // Convert to i64
//                 device_id: rng.gen_range(1..101u64), // u64 range: from 1 to 100
//                 latitude: current_lat,
//                 longitude: current_lon,
//             }
//         })
//         .collect()
// }
