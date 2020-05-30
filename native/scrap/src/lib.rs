use std::{error, fmt, io};

/// A useless Error just for the Demo
#[derive(Copy, Clone, Debug)]
pub struct ScrapError;

impl fmt::Display for ScrapError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Error While Scrapping this page.")
    }
}

impl error::Error for ScrapError {}

impl From<reqwest::Error> for ScrapError {
    fn from(_: reqwest::Error) -> Self {
        Self
    }
}

impl From<io::Error> for ScrapError {
    fn from(_: io::Error) -> Self {
        Self
    }
}

/// Load a page and return its HTML body as a `String`
pub async fn load_page(url: &str) -> Result<String, ScrapError> {
    Ok(reqwest::get(url).await?.text().await?)
}
