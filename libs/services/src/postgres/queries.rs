use serde_json::Value;

pub fn prepare_update_query(json_body: &Value) -> (String, Vec<&Value>) {
    let mut set_clause = Vec::new();
    let mut values = Vec::new();

    if let Value::Object(map) = json_body {
        let mut index = 2; // start from $2 because $1 is used for the ID
        for (key, value) in map.iter() {
            if !value.is_null() {
                set_clause.push(format!("{} = ${}", key, index));
                values.push(value);
                index += 1;
            }
        }
    }

    (set_clause.join(", "), values)
}

pub fn prepare_update_query1(json_body: &Value) -> (String, Vec<&Value>, String) {
    if let Value::Object(map) = json_body {
        let (fields, values, bindings) = map
            .iter()
            .enumerate()
            .filter(|(_, (_, value))| !value.is_null())
            .fold(
                (Vec::new(), Vec::new(), Vec::new()), // (fields, values, bindings)
                |(mut fields, mut values, mut bindings), (i, (key, value))| {
                    fields.push(key.to_string());
                    values.push(value);
                    bindings.push(format!("${}", i + 1));
                    (fields, values, bindings)
                },
            );

        (fields.join(", "), values, bindings.join(", "))
    } else {
        (String::new(), Vec::new(), String::new())
    }
}

pub fn prepare_create_query(json_body: &Value) -> (String, Vec<&Value>, String) {
    let mut fields = Vec::new();
    let mut values = Vec::new();
    let mut bindings = Vec::new();

    let mut index = 1;

    if let Value::Object(map) = json_body {
        for (key, value) in map.iter() {
            if !value.is_null() {
                fields.push(key.to_string());
                values.push(value);
                bindings.push(format!("${}", index));
                index += 1;
            }
        }
    }

    (fields.join(", "), values, bindings.join(", "))
}

#[cfg(test)]
mod update_tests {
    use super::*;
    use serde_json::json;
    // #![feature(test)]
    // extern crate test;
    // use test::Bencher;
    // #[bench]
    // fn bench_add_two(b: &mut Bencher) {
    //   b.iter(|| add_two(2));
    // }
    #[test]
    fn test_prepare_update_query_basic() {
        let json_body = json!({
            "name": "John",
            "age": 30,
            "city": "New York"
        });

        let (query, values) = prepare_update_query(&json_body);

        assert_eq!(query, "name = $2, age = $3, city = $4");
        assert_eq!(values.len(), 3);
        assert_eq!(values[0], &json!("John"));
        assert_eq!(values[1], &json!(30));
        assert_eq!(values[2], &json!("New York"));
    }

    #[test]
    fn test_prepare_update_query_with_null_values() {
        let json_body = json!({
            "name": "John",
            "age": null,
            "city": "New York"
        });

        let (query, values) = prepare_update_query(&json_body);

        assert_eq!(query, "name = $2, city = $3");
        assert_eq!(values.len(), 2);
        assert_eq!(values[0], &json!("John"));
        assert_eq!(values[1], &json!("New York"));
    }

    #[test]
    fn test_prepare_update_query_empty_object() {
        let json_body = json!({});

        let (query, values) = prepare_update_query(&json_body);

        assert_eq!(query, "");
        assert_eq!(values.len(), 0);
    }

    #[test]
    fn test_prepare_update_query_mixed_values() {
        let json_body = json!({
            "name": "John",
            "age": null,
            "city": "New York",
            "occupation": null,
            "country": "USA"
        });

        let (query, values) = prepare_update_query(&json_body);

        assert_eq!(query, "name = $2, city = $3, country = $4");
        assert_eq!(values.len(), 3);
        assert_eq!(values[0], &json!("John"));
        assert_eq!(values[1], &json!("New York"));
        assert_eq!(values[2], &json!("USA"));
    }
}

#[cfg(test)]
mod create_tests {
    use super::*;
    use serde_json::json;

    #[test]
    fn test_prepare_create_query_basic() {
        let json_body = json!({
            "name": "John",
            "age": 30,
            "city": "New York"
        });

        let (fields, values, bindings) = prepare_create_query(&json_body);

        assert_eq!(fields, "name, age, city");
        assert_eq!(bindings, "$1, $2, $3");
        assert_eq!(values.len(), 3);
        assert_eq!(values[0], &json!("John"));
        assert_eq!(values[1], &json!(30));
        assert_eq!(values[2], &json!("New York"));
    }

    #[test]
    fn test_prepare_create_query_with_null_values() {
        let json_body = json!({
            "name": "John",
            "age": null,
            "city": "New York"
        });

        let (fields, values, bindings) = prepare_create_query(&json_body);

        assert_eq!(fields, "name, city");
        assert_eq!(bindings, "$1, $2");
        assert_eq!(values.len(), 2);
        assert_eq!(values[0], &json!("John"));
        assert_eq!(values[1], &json!("New York"));
    }

    #[test]
    fn test_prepare_create_query_empty_object() {
        let json_body = json!({});

        let (fields, values, bindings) = prepare_create_query(&json_body);

        assert_eq!(fields, "");
        assert_eq!(bindings, "");
        assert_eq!(values.len(), 0);
    }

    #[test]
    fn test_prepare_create_query_mixed_values() {
        let json_body = json!({
            "name": "John",
            "age": null,
            "city": "New York",
            "occupation": null,
            "country": "USA"
        });

        let (fields, values, bindings) = prepare_create_query(&json_body);

        assert_eq!(fields, "name, city, country");
        assert_eq!(bindings, "$1, $2, $3");
        assert_eq!(values.len(), 3);
        assert_eq!(values[0], &json!("John"));
        assert_eq!(values[1], &json!("New York"));
        assert_eq!(values[2], &json!("USA"));
    }
}
