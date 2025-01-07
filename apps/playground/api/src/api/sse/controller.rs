use axum::response::sse::{Event, Sse};
use axum_extra::TypedHeader;
use chrono::Utc;
use futures::stream::{self, Stream};
use log::info;
use serde_json::json;
use std::{convert::Infallible, time::Duration};
use tokio_stream::StreamExt as _;

/// SEE endpoint handler
#[utoipa::path(
  get,
  path = "/api/see",
  tag = "SEE",
  responses(
  (status = 200, description = "Success data"),
  ),
)]
pub async fn sse_handler(
  TypedHeader(user_agent): TypedHeader<headers::UserAgent>,
) -> Sse<impl Stream<Item = Result<Event, Infallible>>> {
  info!("`{}` connected", user_agent.as_str());
  // Create JSON data
  let json_data = json!({
        "message": "Hello!",
        "user_agent": user_agent.as_str(),
        "timestamp": Utc::now().to_rfc3339(),
    });
  // A `Stream` that repeats an event every second
  //
  // You can also create streams from tokio channels using the wrappers in
  // https://docs.rs/tokio-stream
  let stream = stream::repeat_with(move || {
    let data = json_data.clone().to_string();
    Event::default().data(data)
  })
    .map(Ok)
    .throttle(Duration::from_secs(1));

  Sse::new(stream).keep_alive(
    axum::response::sse::KeepAlive::new()
      .interval(Duration::from_secs(1))
      .text("keep-alive-text"),
  )
}
