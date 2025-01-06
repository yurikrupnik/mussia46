use super::query_param_processing::QueryParamProcessing;
use mongodb::bson::{doc, Document};
use mongodb::options::FindOptions;
use std::error::Error;

/// Generic function that works with any type that implements QueryParamProcessing
pub fn construct_find_options_and_filter<T: QueryParamProcessing>(
    mut query: T,
) -> Result<(Document, FindOptions), Box<dyn Error>> {
    let mut options = FindOptions::builder().build();

    if let Some(limit) = query.get_limit() {
        options.limit = Some(limit.parse::<i64>()?);
        query.clear_limit();
    }
    if let Some(projection) = query.get_projection() {
        let doc = if projection.contains(',') {
            projection.split(',').fold(doc! {}, |mut acc, item| {
                acc.insert(item.trim(), 1);
                acc
            })
        } else {
            doc! { projection: 1 }
        };
        options.projection = Some(doc);
        query.clear_projection();
    }
    // Convert the remaining query parameters into a MongoDB filter document
    let query_params_json = query.into_inner();
    let filter = serde_json::from_value::<Document>(query_params_json)?;

    Ok((filter, options))
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;
    #[test]
    fn test_construct_find_options_and_filter() {
        struct MockQuery {
            limit: Option<String>,
            projection: Option<String>,
            inner: serde_json::Value,
        }
        impl QueryParamProcessing for MockQuery {
            fn get_limit(&self) -> Option<String> {
                self.limit.clone()
            }

            fn clear_limit(&mut self) {
                self.limit = None;
            }

            fn get_projection(&self) -> Option<String> {
                self.projection.clone()
            }

            fn clear_projection(&mut self) {
                self.projection = None;
            }

            fn into_inner(self) -> serde_json::Value {
                self.inner
            }
        }
        let query = MockQuery {
            limit: Some("10".to_string()),
            projection: Some("field1,field2".to_string()),
            inner: json!({ "field": "value" }),
        };

        let (filter, options) = construct_find_options_and_filter(query).unwrap();

        assert_eq!(filter, doc! { "field": "value" });
        assert_eq!(options.limit, Some(10));
        assert_eq!(
            options.projection.unwrap(),
            doc! { "field1": 1, "field2": 1 }
        );
    }
}
