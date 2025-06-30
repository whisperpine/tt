use axum_extra::extract::{CookieJar, Host};
use http::Method;
use tt_openapi::apis::echo::EchoBackResponse;

#[async_trait::async_trait]
impl tt_openapi::apis::echo::Echo<crate::Error> for crate::ServerImpl {
    async fn echo_back(
        &self,
        _method: &Method,
        _host: &Host,
        _cookies: &CookieJar,
        body: &String,
    ) -> crate::Result<EchoBackResponse> {
        tracing::trace!(%body, "#echo_back#");
        let resp = EchoBackResponse::Status200_SuccessfulResponse(body.clone());
        Ok(resp)
    }
}
