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
pub enum GetUserByIdResponse {
    /// Successful response
    Status200_SuccessfulResponse(models::User),
    /// User not found
    Status404_UserNotFound,
}

#[derive(Debug, PartialEq, Serialize, Deserialize)]
#[must_use]
#[allow(clippy::large_enum_variant)]
pub enum ListUsersResponse {
    /// Successful response with list of users
    Status200_SuccessfulResponseWithListOfUsers(Vec<models::User>),
    /// User not found
    Status404_UserNotFound,
}

/// Users
#[async_trait]
#[allow(clippy::ptr_arg)]
pub trait Users<E: std::fmt::Debug + Send + Sync + 'static = ()>: super::ErrorHandler<E> {
    /// Get user information by ID.
    ///
    /// GetUserById - GET /users/{user_id}
    async fn get_user_by_id(
        &self,

        method: &Method,
        host: &Host,
        cookies: &CookieJar,
        path_params: &models::GetUserByIdPathParams,
    ) -> Result<GetUserByIdResponse, E>;

    /// List all users.
    ///
    /// ListUsers - GET /users
    async fn list_users(
        &self,

        method: &Method,
        host: &Host,
        cookies: &CookieJar,
    ) -> Result<ListUsersResponse, E>;
}
