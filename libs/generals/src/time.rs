use time::{format_description::well_known::Rfc3339, Duration, OffsetDateTime};

pub fn now_utc() -> OffsetDateTime {
    OffsetDateTime::now_utc()
}

pub fn format_time(time: OffsetDateTime) -> Result<String> {
    let format = time
        .format(&Rfc3339)
        .map_err(|_| Error::FailToDateParse(time.to_string()))?;
    Ok(format)
}

pub fn now_utc_plus_sec_str(sec: f64) -> String {
    let new_time = now_utc() + Duration::seconds_f64(sec);
    match format_time(new_time) {
        a => {
            tracing::trace!("do it");
            let sa = a.unwrap();
            tracing::debug!("my data: {}", sa);
            sa
        }
        Err(e) => {
            tracing::error!("error: {}", &e);
            // Err(e);
            "fucked uo".to_string()
        }
    }
}

pub fn parse_utc(moment: &str) -> Result<OffsetDateTime> {
    OffsetDateTime::parse(moment, &Rfc3339).map_err(|_| Error::FailToDateParse(moment.to_string()))
}

// region:    --- Error

pub type Result<T> = core::result::Result<T, Error>;

#[derive(Debug)]
pub enum Error {
    FailToDateParse(String),
}

// region:    --- Error Boilerplate
impl core::fmt::Display for Error {
    fn fmt(&self, fmt: &mut core::fmt::Formatter) -> core::result::Result<(), core::fmt::Error> {
        write!(fmt, "{self:?}")
    }
}

impl std::error::Error for Error {}
// endregion: --- Error Boilerplate

// endregion: --- Error
