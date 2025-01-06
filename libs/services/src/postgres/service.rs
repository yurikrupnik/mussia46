use crate::postgres::queries::{prepare_create_query, prepare_update_query};
use proc_macros::DbResource;
use serde_json::Value;
use sqlx::types::uuid;
use sqlx::{postgres::PgQueryResult, query, query_as, PgPool, Result};
use std::fmt::Debug;
use tracing::{debug, error, info, instrument, span, warn, Level};
use uuid::Uuid;

pub trait SqlMethods<
    T: DbResource + Send + Unpin + for<'r> sqlx::FromRow<'r, sqlx::postgres::PgRow>,
    C: serde::Serialize,
    U: serde::Serialize,
>
{
    async fn get_list(pool: &PgPool, query: &Option<&str>) -> Result<Vec<T>> {
        let str = query.unwrap_or("");
        let query_string = format!("SELECT * FROM {} {str}", T::COLLECTION);
        let query_string_trimmed = query_string.trim();
        let data = query_as::<_, T>(query_string_trimmed)
            .fetch_all(pool)
            .await?;
        Ok(data)
    }
    async fn drop_collection(pool: &PgPool) -> Result<PgQueryResult> {
        query(&format!("DELETE FROM {}", T::COLLECTION))
            .execute(pool)
            .await
    }
    async fn delete_by_id(pool: &PgPool, id: &Uuid) -> Result<PgQueryResult> {
        query(&format!("DELETE FROM {} WHERE id = $1", T::COLLECTION))
            .bind(id)
            .execute(pool)
            .await
    }
    async fn get_by_id(pool: &PgPool, id: &Uuid) -> Result<T> {
        let data = query_as::<_, T>(&format!("SELECT * FROM {} where id = $1", T::COLLECTION))
            .bind(id)
            .fetch_one(pool)
            .await?;
        Ok(data)
    }
    async fn create_item(pool: &PgPool, body: &C) -> Result<T> {
        let json_body = serde_json::to_value(body).expect("Failed to serialize body");

        let (fields, values, bindings) = prepare_create_query(&json_body);

        let query = format!(
            "INSERT INTO {} ({}) VALUES ({}) RETURNING *",
            T::COLLECTION,
            fields,
            bindings
        );

        let result = fetch_by_values(&query, values, pool, None).await?;
        Ok(result)
    }
    async fn update_by_id(pool: &PgPool, id: &Uuid, body: &U) -> Result<T> {
        let span = span!(Level::INFO, "some_handler");
        let _enter = span.enter();

        debug!("Handler logic starts");
        info!("Handler logic starts");
        let json_body = serde_json::to_value(body).expect("Failed to serialize body");
        let (set_clause, values) = prepare_update_query(&json_body);
        if set_clause.is_empty() {
            return Err(sqlx::Error::ColumnNotFound(
                "No fields to update".to_string(),
            ));
        }
        let query = format!(
            "UPDATE {} SET {} WHERE id = $1 RETURNING *",
            T::COLLECTION,
            set_clause
        );
        let result = fetch_by_values(&query, values, pool, Some(id)).await?;
        Ok(result)
    }
}

/// Drop a table - SQLx
pub async fn drop_collection<T>(pool: &PgPool) -> Result<PgQueryResult>
where
    T: DbResource,
{
    query(&format!("DELETE FROM {}", T::COLLECTION))
        .execute(pool)
        .await
}

/// Delete an item by its ID - SQLx
pub async fn delete_by_id<T>(pool: &PgPool, id: &Uuid) -> Result<PgQueryResult>
where
    T: DbResource,
{
    query(&format!("DELETE FROM {} WHERE id = $1", T::COLLECTION))
        .bind(id)
        .execute(pool)
        .await
}

/// Get an item by its ID - SQLx
pub async fn get_by_id<T>(pool: &PgPool, id: &Uuid) -> Result<T>
where
    T: DbResource + Send + Unpin + for<'r> sqlx::FromRow<'r, sqlx::postgres::PgRow>,
{
    let data = query_as::<_, T>(&format!("SELECT * FROM {} where id = $1", T::COLLECTION))
        .bind(id)
        .fetch_one(pool)
        .await?;
    Ok(data)
}

/// Get list by query - SQLx
pub async fn get_list<T>(pool: &PgPool, query: &Option<&str>) -> Result<Vec<T>>
where
    T: DbResource + Send + Unpin + for<'r> sqlx::FromRow<'r, sqlx::postgres::PgRow>,
{
    let str = query.unwrap_or("");
    let qq = format!("SELECT * FROM {} {str}", T::COLLECTION);
    let sd = qq.trim();
    let data = query_as::<_, T>(sd).fetch_all(pool).await?;
    Ok(data)
}

/// Update an item by its ID - SQLx
// #[tracing::instrument(skip(pool))]
pub async fn update_by_id<T, U>(pool: &PgPool, id: &Uuid, body: &U) -> Result<T>
where
    T: DbResource + Send + Unpin + for<'r> sqlx::FromRow<'r, sqlx::postgres::PgRow> + Debug,
    U: serde::Serialize + Debug,
{
    // let fetch_span = span!(Level::INFO, "fetch_task");
    // let _enter = fetch_span.enter();
    // error!("aris is here");
    let json_body = serde_json::to_value(body).expect("Failed to serialize body");

    let (set_clause, values) = prepare_update_query(&json_body);
    if set_clause.is_empty() {
        return Err(sqlx::Error::ColumnNotFound(
            "No fields to update".to_string(),
        ));
    }

    let query = format!(
        "UPDATE {} SET {} WHERE id = $1 RETURNING *",
        T::COLLECTION,
        set_clause
    );
    let result = fetch_by_values(&query, values, pool, Some(id)).await?;
    Ok(result)
}

/// Create an item - SQLx
pub async fn create_item<T, U>(pool: &PgPool, body: &U) -> Result<T>
where
    T: DbResource + Send + Sync + Unpin + for<'r> sqlx::FromRow<'r, sqlx::postgres::PgRow>,
    U: serde::Serialize,
{
    let json_body = serde_json::to_value(body).expect("Failed to serialize body");

    let (fields, values, bindings) = prepare_create_query(&json_body);

    let query = format!(
        "INSERT INTO {} ({}) VALUES ({}) RETURNING *",
        T::COLLECTION,
        fields,
        bindings
    );

    let result = fetch_by_values(&query, values, pool, None).await?;
    Ok(result)
}

async fn fetch_by_values<T>(
    query: &str,
    values: Vec<&Value>,
    pool: &PgPool,
    id: Option<&Uuid>,
) -> Result<T>
where
    T: Send + Unpin + for<'r> sqlx::FromRow<'r, sqlx::postgres::PgRow>,
{
    let mut sql_query = sqlx::query_as::<_, T>(query);
    // Conditionally bind the UUID if provided
    if let Some(uuid) = id {
        sql_query = sql_query.bind(uuid);
    }
    // println!("uuid", uuid);
    for value in values {
        sql_query = match value {
            Value::String(s) => sql_query.bind(s),
            Value::Number(n) if n.is_i64() => sql_query.bind(n.as_i64().unwrap()),
            Value::Number(n) if n.is_f64() => sql_query.bind(n.as_f64().unwrap()),
            Value::Bool(b) => sql_query.bind(*b),
            // _ => sql_query.bind(value),
            _ => {
                return Err(sqlx::Error::ColumnDecode {
                    index: "value".into(),
                    source: Box::new(std::io::Error::new(
                        std::io::ErrorKind::InvalidInput,
                        "Unsupported type for `value`",
                    )),
                });
                // AppError::S
                // return Err(AppError::UnsupportedValueType); // You might want a more specific error
                // return Err(sqlx::Error::ColumnDecode {
                //     index: "value".into(),
                //     source: Box::new(std::io::Error::new(
                //         std::io::ErrorKind::InvalidInput,
                //         "Unsupported type for `value`",
                //     )),
                // });
            }
        };
    }
    let resource = sql_query.fetch_one(pool).await
    //   .map_err(|e| {
    //     if let sqlx::Error::RowNotFound = e {
    //         let message = construct_not_found_message(id);
    //         AppError::NotFound(message)
    //     } else {
    //         AppError::DatabaseError(e.to_string())
    //     }
    // })
    ?;
    Ok(resource)
}
fn construct_not_found_message(id: Option<&Uuid>) -> String {
    match id {
        Some(uuid) => format!("Resource with ID {} not found.", uuid),
        None => "Resource not found.".to_string(),
    }
}
