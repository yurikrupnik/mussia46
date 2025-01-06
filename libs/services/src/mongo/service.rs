use mongodb::{
    bson::{
        oid::{self, ObjectId},
        {doc, to_document, Document},
    },
    error::Result,
    results::DeleteResult,
    Collection, Database,
};
// use mongodb::error::Result;
// use mongodb::results::DeleteResult;
// use mongodb::{Collection, Database};
use proc_macros::DbResource;
use serde::de::DeserializeOwned;
use serde::Serialize;

// pub fn create_query_id(id: &str) -> Result<Document, MongoErrors> {
//     let obj_id = ObjectId::parse_str(id).map_err(MongoErrors::Oid)?;
//     Ok(doc! {"_id": obj_id})
// }

pub fn create_query_id(id: &str) -> Document {
    let obj_id = ObjectId::parse_str(id).expect("failed to parse id");
    doc! {"_id": obj_id}
}
// use thiserror::Error;

#[derive(Debug, thiserror::Error)]
enum MongoErrors {
    // Io(#[from] std::io::Error),
    // Mongo(#[from] error::Error),
    #[error("Not Found")]
    Stam,
    #[error("Not Found")]
    Oid(#[from] oid::Error),
}

pub trait MongoMethods<
    T: DbResource + serde::Serialize + DeserializeOwned + Sync + Send + Unpin,
    C: serde::Serialize,
    U: serde::Serialize,
>
{
    async fn create_item(db: &Database, item: &U) -> Result<Option<Document>> {
        let collection = db.collection(T::COLLECTION);
        let document = to_document(item)?;
        let result = collection.insert_one(document).await?;
        let object_id = result.inserted_id.as_object_id().expect("error 1");
        let filter = doc! {"_id": object_id};
        let response = collection.find_one(filter).await?;
        Ok(response)
    }
    async fn drop_collection(db: &Database) -> Result<()> {
        let collection: Collection<Document> = db.collection(T::COLLECTION);
        collection.drop().await?;
        Ok(())
    }
    async fn delete_by_id(db: &Database, id: &str) -> Result<DeleteResult> {
        let filter = create_query_id(id);
        let collection: Collection<Document> = db.collection(T::COLLECTION);
        let result = collection.delete_one(filter).await?;
        Ok(result)
    }
    async fn get_by_id(db: &Database, id: &str) -> Result<Option<T>> {
        let collection: Collection<T> = db.collection(T::COLLECTION);
        let filter = create_query_id(id);
        let result = collection.find_one(filter).await?;
        Ok(result)
    }
    async fn update_by_id(db: &Database, body: U, id: &str) -> Result<Option<Document>> {
        let filter = create_query_id(id);
        let collection: Collection<Document> = db.collection(T::COLLECTION);
        let serialized_item = to_document(&body)?;
        let new_doc = doc! {
            "$set": serialized_item
        };
        // let options = FindOneAndUpdateOptions::builder()
        //     .return_document(ReturnDocument::After)
        //     .build();
        let result = collection.find_one_and_update(filter, new_doc).await?;
        Ok(result)
    }
}
/// hello there!!!!
pub async fn create_item<T, U>(db: &Database, item: &U) -> Result<Option<Document>>
where
    T: DbResource + Serialize + DeserializeOwned + Sync + Send + Unpin,
    U: Serialize + DeserializeOwned + Sync + Send + Unpin + 'static,
{
    let collection = db.collection(T::COLLECTION);
    let document = to_document(item)?;
    let result = collection.insert_one(document).await?;
    // let object_id = result.inserted_id.as_object_id();
    // match object_id {
    //     None => Err(anyhow::anyhow!("stam error")),
    //     Some(v) => {
    //         let filter = doc! {"_id": v};
    //         let response = collection.find_one(filter).await?;
    //         Ok(response)
    //     }
    // }
    let object_id = result.inserted_id.as_object_id().expect("error 1");
    let filter = doc! {"_id": object_id};
    let response = collection.find_one(filter).await?;
    Ok(response)
}

/// Drop a collection - MongoDB
pub async fn drop_collection<T: DbResource>(db: &Database) -> Result<()> {
    let collection: Collection<Document> = db.collection(T::COLLECTION);
    collection.drop().await?;
    Ok(())
}

/// Delete an item by its ID - MongoDB
pub async fn delete_by_id<T>(db: &Database, id: &str) -> Result<DeleteResult>
where
    T: DbResource,
{
    let filter = create_query_id(id);
    let collection: Collection<Document> = db.collection(T::COLLECTION);
    let result = collection.delete_one(filter).await?;
    Ok(result)
}

pub async fn get_by_id<T>(db: &Database, id: &str) -> Result<Option<T>>
where
    T: DbResource + DeserializeOwned + Serialize + Sync + Send + Unpin,
{
    let collection: Collection<T> = db.collection(T::COLLECTION);
    let filter = create_query_id(id);
    let result = collection.find_one(filter).await?;
    Ok(result)
}

pub async fn update_by_id<T, U>(db: &Database, body: U, id: &str) -> Result<Option<Document>>
where
    T: DbResource + DeserializeOwned + Serialize,
    U: DeserializeOwned + Serialize,
{
    let filter = create_query_id(id);
    let collection: Collection<Document> = db.collection(T::COLLECTION);
    let serialized_item = to_document(&body)?;
    let new_doc = doc! {
        "$set": serialized_item
    };
    // let options = FindOneAndUpdateOptions::builder()
    //     .return_document(ReturnDocument::After)
    //     .build();
    let result = collection.find_one_and_update(filter, new_doc).await?;
    Ok(result)
}

// pub async fn get_list<T, Q>(db: &Database, query: Q) -> Result<Vec<T>>
// where
//     T: DbResource + DeserializeOwned + Serialize,
//     Q: DeserializeOwned + Serialize + Clone,
// {
//     let collection: Collection<T> = db.collection(T::COLLECTION);
//     let (filter, options) = construct_find_options_and_filter(query.clone()).unwrap();
//     let mut cursor = collection
//         .find(filter, options)
//         .await
//         .expect("failed fetching");
//     let mut payload: Vec<T> = Vec::new();
//     while let Some(item) = cursor
//         .try_next()
//         .await
//         .expect("Error mapping through cursor")
//     {
//         payload.push(item);
//     }
//     Ok(payload)
// }

#[cfg(test)]
mod tests {
    // use utoipa::IntoParams;
    use super::*;
    use serde::Deserialize;

    struct Test1 {
        name: String,
    }
    struct CreateTest1 {
        name: String,
    }
    struct UpdateTest1 {
        name: String,
    }

    #[derive(Clone, Deserialize, Serialize, Debug)]
    #[serde(deny_unknown_fields)]
    pub struct TodoQueryParams {
        #[serde(skip_serializing_if = "Option::is_none")]
        completed: Option<bool>,
        #[serde(skip_serializing_if = "Option::is_none")]
        text: Option<String>,
        #[serde(skip_serializing_if = "Option::is_none")]
        pub limit: Option<String>,
        #[serde(skip_serializing_if = "Option::is_none")]
        pub total: Option<String>,
        #[serde(skip_serializing_if = "Option::is_none")]
        pub skip: Option<String>,
        #[serde(skip_serializing_if = "Option::is_none")]
        pub projection: Option<String>,
    }
    #[test]
    fn generic_routes_basic() {
        // let db =
        // let s = delete_by_id::<Test1>(db: &Database, id: &str);
        // let s = generic_routes::<Test1, CreateTest1, UpdateTest1,TodoQueryParams>();
        let result = 2 + 2;
        assert_eq!(result, 4);
    }
}
