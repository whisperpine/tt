use async_trait::async_trait;
use axum::extract::*;
use axum_extra::extract::{CookieJar, Host};
use bytes::Bytes;
use http::Method;
use serde::{Deserialize, Serialize};

use crate::{models, types::*};

#[derive(Debug, PartialEq, Serialize, Deserialize)]
#[must_use]
#[allow(clippy::large_enum_variant)]
pub enum EchoBackResponse {
    /// Successful response
    Status200_SuccessfulResponse(String),
    /// Bad request
    Status400_BadRequest,
}

/// Echo
#[async_trait]
#[allow(clippy::ptr_arg)]
pub trait Echo<E: std::fmt::Debug + Send + Sync + 'static = ()>: super::ErrorHandler<E> {
    /// Echo the request body.
    ///
    /// EchoBack - POST /echo
    async fn echo_back(
        &self,
        method: &Method,
        host: &Host,
        cookies: &CookieJar,
        body: &String,
    ) -> Result<EchoBackResponse, E>;
}
