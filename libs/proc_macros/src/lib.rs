pub use db_resource::DbResource;
pub use reflective::Reflective;

pub trait Reflective {
    fn name() -> &'static str;
    fn field_names() -> Vec<&'static str>;
    fn field_values(&self) -> Vec<String>;
}

pub trait DbResource {
    const URL: &'static str;
    const URL_WITH_ID: &'static str;
    const COLLECTION: &'static str;
    const TAG: &'static str;
    // const SHIT: &'static str;
    // fn shit(s: &str) -> String;
}
