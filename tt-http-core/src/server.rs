mod echo;
mod user;

#[derive(Debug)]
pub(crate) struct ServerImpl {
    // todo: e.g. database connection
}

#[async_trait::async_trait]
impl tt_openapi::apis::ErrorHandler<crate::Error> for ServerImpl {}

/// Starts the HTTP server and binds it to the specified address.
///
/// ## Panics
/// This function will panic if:
/// - The server fails to bind to the specified [`SocketAddr`].
/// - The server fails to start serving requests ([`axum::serve`]).
pub async fn start_server(addr: std::net::SocketAddr) {
    // Init Axum router.
    let server_impl = std::sync::Arc::new(ServerImpl {});
    let app = tt_openapi::server::new(server_impl);

    tracing::info!("app version: {}", crate::PKG_VERSION);
    tracing::info!("openapi version: {}", tt_openapi::API_VERSION);

    let listener = tokio::net::TcpListener::bind(addr)
        .await
        .unwrap_or_else(|e| {
            tracing::error!("{e}");
            panic!("failed to bind SocketAddr: {addr}")
        });
    tracing::info!("listening at http://localhost:{}", addr.port());

    axum::serve(listener, app).await.unwrap_or_else(|e| {
        tracing::error!("{e}");
        panic!("failed to start axum server")
    });
}
