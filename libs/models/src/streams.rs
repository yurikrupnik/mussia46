use clap::builder::Str;
use serde::{Deserialize, Serialize};
use std::str::FromStr;
use strum::{self, AsRefStr, Display, EnumString};

#[derive(serde::Serialize, serde::Deserialize)]
pub struct ReadDto {
    pub id: String,
}

impl ReadDto {
    pub fn new(id: String) -> Self {
        Self { id }
    }
}

#[derive(serde::Serialize, serde::Deserialize)]
pub struct DeleteDto {
    pub id: String,
}

impl DeleteDto {
    pub fn new(id: String) -> Self {
        Self { id }
    }
}

enum ActionsDto {
    Read { id: String },
    Delete { id: String },
    List { id: String },
    Update { id: String },
}

#[derive(Debug, Display, AsRefStr, EnumString)]
#[strum(serialize_all = "snake_case")]
pub enum StreamKeys {
    Payload,
    RequestId,
    Action,
}

#[derive(Debug, Display, AsRefStr, EnumString)]
#[strum(serialize_all = "snake_case")]
pub enum CrudActions {
    Read,
    Create,
    List,
    Update,
    Delete,
    Drop,
}

// Enum solution
pub enum Stream {
    Users,
    Tasks,
}

impl FromStr for Stream {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "users_stream" => Ok(Stream::Users),
            "tasks_stream" => Ok(Stream::Tasks),
            _ => Err(()),
        }
    }
}

impl Stream {
    /// Returns the string representation of the stream.
    pub fn as_str(&self) -> &'static str {
        match self {
            Stream::Users => "users_stream",
            Stream::Tasks => "tasks_stream",
        }
    }

    /// Returns all stream names as a slice.
    pub fn all_streams() -> [&'static str; 2] {
        [Stream::Users.as_str(), Stream::Tasks.as_str()]
    }
}

// Consts solution
pub const USERS_STREAM: &str = "users_stream";
pub const TASKS_STREAM: &str = "tasks_stream";

pub const CREATE: &str = "create";
pub const DELETE: &str = "delete";
pub const UPDATE: &str = "update";
pub static GROUP_NAME: &str = "mygroup";
pub static PAYLOAD: &str = "payload";
pub static REDIS_STREAMS: [&str; 2] = [TASKS_STREAM, USERS_STREAM];

// impl ToRedisArgs for RedisStreams {
//     fn write_redis_args<W: ?Sized + RedisWrite>(&self, out: &mut W) {
//         // Manually convert to JSON and push as one argument
//         let as_json = serde_json::to_string(self).unwrap();
//         out.write_arg(as_json.as_bytes());
//     }
// }
