fn main() {
    println!("hello")
}

// use chrono::prelude::*;
// use polars::prelude::*;
// use reqwest;
// use serde::{Deserialize, Serialize};
// use std::collections::HashMap;
//
// // fn ads() {
// //   let mut df: DataFrame = df!(
// //     "name" => ["Alice Archer", "Ben Brown", "Chloe Cooper", "Daniel Donovan"],
// //     "birthdate" => [
// //         NaiveDate::from_ymd_opt(1997, 1, 10).unwrap(),
// //         NaiveDate::from_ymd_opt(1985, 2, 15).unwrap(),
// //         NaiveDate::from_ymd_opt(1983, 3, 22).unwrap(),
// //         NaiveDate::from_ymd_opt(1981, 4, 30).unwrap(),
// //     ],
// //     "weight" => [57.9, 72.5, 53.6, 83.1],  // (kg)
// //     "height" => [1.56, 1.77, 1.65, 1.75],  // (m)
// // )
// //     .unwrap();
// //   println!("{}", df);
// // }
// #[derive(Debug, Serialize, Deserialize)]
// struct CloudProvider {
//     name: String,
//     compute_price_per_hour: f64,
//     storage_price_per_gb: f64,
//     networking_price_per_gb: f64,
// }
//
// impl CloudProvider {
//     fn total_price(&self, compute_hours: f64, storage_gb: f64, networking_gb: f64) -> f64 {
//         (self.compute_price_per_hour * compute_hours)
//             + (self.storage_price_per_gb * storage_gb)
//             + (self.networking_price_per_gb * networking_gb)
//     }
// }
//
// #[tokio::main]
// async fn main() -> Result<(), Box<dyn std::error::Error>> {
//     let mut df: DataFrame = df!(
//         "name" => ["Alice Archer", "Ben Brown", "Chloe Cooper", "Daniel Donovan"],
//         "birthdate" => [
//             NaiveDate::from_ymd_opt(1997, 1, 10).unwrap(),
//             NaiveDate::from_ymd_opt(1985, 2, 15).unwrap(),
//             NaiveDate::from_ymd_opt(1983, 3, 22).unwrap(),
//             NaiveDate::from_ymd_opt(1981, 4, 30).unwrap(),
//         ],
//         "weight" => [57.9, 72.5, 53.6, 83.1],  // (kg)
//         "height" => [1.56, 1.77, 1.65, 1.75],  // (m)
//     )
//     .unwrap();
//     println!("{}", df);
//     let result = df
//         .clone()
//         .lazy()
//         .select([
//             col("name"),
//             (col("weight") / col("height").pow(2)).alias("bmi"),
//         ])
//         .collect()?;
//     println!("{}", result);
//     let result = df
//         .clone()
//         .lazy()
//         .select([
//             col("name"),
//             (cols(["weight", "height"]) * lit(0.95))
//                 .round(2)
//                 .name()
//                 .suffix("-5%"),
//         ])
//         .collect()?;
//     println!("{}", result);
//     let result = df
//         .clone()
//         .lazy()
//         .with_columns([
//             col("birthdate").dt().year().alias("birth_year"),
//             (col("weight") / col("height").pow(2)).alias("bmi"),
//         ])
//         .collect()?;
//     println!("{}", result);
//     let cloud_providers = vec![
//         CloudProvider {
//             name: "aws".to_string(),
//             compute_price_per_hour: 0.092, // AWS EC2 t3.medium
//             storage_price_per_gb: 0.023,   // AWS S3 Standard
//             networking_price_per_gb: 0.09, // AWS data transfer
//         },
//         CloudProvider {
//             name: "azure".to_string(),
//             compute_price_per_hour: 0.085, // Azure VM Standard_D2s_v3
//             storage_price_per_gb: 0.0184,  // Azure Blob Storage
//             networking_price_per_gb: 0.08, // Azure egress pricing
//         },
//         CloudProvider {
//             name: "gcp".to_string(),
//             compute_price_per_hour: 0.084, // GCP N1 Standard
//             storage_price_per_gb: 0.020,   // GCP Cloud Storage
//             networking_price_per_gb: 0.08, // GCP egress pricing
//         },
//     ];
//
//     // Example usage: compute instance for 100 hours, 500GB storage, 50GB networking
//     let compute_hours = 100.0;
//     let storage_gb = 500.0;
//     let networking_gb = 50.0;
//
//     let mut price_map: HashMap<String, f64> = HashMap::new();
//
//     for provider in &cloud_providers {
//         let total_cost = provider.total_price(compute_hours, storage_gb, networking_gb);
//         price_map.insert(provider.name.clone(), total_cost);
//         println!("{} total cost: ${:.2}", provider.name, total_cost);
//     }
//
//     let cheapest = price_map
//         .iter()
//         .min_by(|a, b| a.1.partial_cmp(b.1).unwrap())
//         .unwrap();
//     println!("\nCheapest Provider: {} - ${:.2}", cheapest.0, cheapest.1);
//
//     Ok(())
// }
