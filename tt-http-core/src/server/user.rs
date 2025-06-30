use axum_extra::extract::{CookieJar, Host};
use http::Method;
use tt_openapi::apis::users::{GetUserByIdResponse, ListUsersResponse};
use tt_openapi::models;

#[async_trait::async_trait]
impl tt_openapi::apis::users::Users<crate::Error> for crate::ServerImpl {
    /// Get user information by ID.
    ///
    /// GetUserById - GET /users/{user_id}
    async fn get_user_by_id(
        &self,
        _method: &Method,
        _host: &Host,
        _cookies: &CookieJar,
        path_params: &models::GetUserByIdPathParams,
    ) -> crate::Result<GetUserByIdResponse> {
        // todo
        tracing::warn!(
            "#get_user_by_id# this function should be implemented later. now responding with mock data."
        );

        let id = path_params.user_id;
        tracing::trace!(%id, "#get_user_by_id#");
        let mock_user = models::User {
            id,
            username: "amiao".to_owned(),
            email: "amiao@cat.com".to_owned(),
        };
        Ok(GetUserByIdResponse::Status200_SuccessfulResponse(mock_user))
    }

    /// List all users.
    ///
    /// ListUsers - GET /users
    async fn list_users(
        &self,
        _method: &Method,
        _host: &Host,
        _cookies: &CookieJar,
    ) -> crate::Result<ListUsersResponse> {
        // todo
        tracing::warn!(
            "#list_users# this function should be implemented later. now responding with mock data."
        );

        tracing::trace!("#list_users#");
        let amiao = models::User {
            id: uuid::Uuid::new_v4(),
            username: "amiao".to_owned(),
            email: "amiao@cat.com".to_owned(),
        };

        let yahaha = models::User {
            id: uuid::Uuid::new_v4(),
            username: "yahaha".to_owned(),
            email: "yahaha@yahi.com".to_owned(),
        };
        Ok(ListUsersResponse::Status200_SuccessfulResponseWithListOfUsers(vec![amiao, yahaha]))
    }
}
