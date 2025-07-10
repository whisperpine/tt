/// Creates a PostgreSQL connection pool with the specified database URL.
///
/// ## Panics
/// This function will panic if it fails to establish a connection to the database.
///
/// ## Examples
/// ```rust,ignore
/// #[tokio::main]
/// async fn main() {
///     let pool = connection_pool("postgres://user:password@localhost/db").await;
/// }
/// ```
pub(crate) async fn connection_pool(database_url: &str) -> sqlx::PgPool {
    sqlx::postgres::PgPoolOptions::new()
        .max_connections(*crate::MAX_DB_CONNECTIONS)
        .acquire_timeout(*crate::DB_CONNECTION_TIMEOUT)
        .connect(database_url)
        .await
        .unwrap_or_else(|e| panic!("failed to connect to postgres. error: {e}"))
}
