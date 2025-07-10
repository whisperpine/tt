use std::sync::LazyLock;
use std::time::Duration;

/// Program version.
pub const PKG_VERSION: &str = env!("CARGO_PKG_VERSION");

/// Crate name.
pub const CRATE_NAME: &str = env!("CARGO_CRATE_NAME");

/// Env var which is used to set [`MAX_DB_CONNECTIONS`].
const MAX_DB_CONN: &str = "MAX_DB_CONN";

/// Max connections to PostgreSQL used by sqlx.
///
/// If env var `MAX_DB_CONN` hans't been set, the default value 5 will be set.
pub(crate) static MAX_DB_CONNECTIONS: LazyLock<u32> =
    LazyLock::new(|| match std::env::var(MAX_DB_CONN) {
        Ok(value) => value
            .parse::<u32>()
            .unwrap_or_else(|e| panic!("{MAX_DB_CONN} should be an unsigned integer. error: {e}")),
        Err(_) => {
            let default_value: u32 = 5;
            tracing::debug!(
                "env var {MAX_DB_CONN} hasn't been set, using default value: {default_value}",
            );
            default_value
        }
    });

/// Env var which is used to set [`DB_CONNECTION_TIMEOUT`].
const DB_CONN_TIMEOUT: &str = "DB_CONN_TIMEOUT";

/// The maximum amount of time to spend waiting for a connection.
pub(crate) static DB_CONNECTION_TIMEOUT: LazyLock<Duration> =
    LazyLock::new(|| match std::env::var(DB_CONN_TIMEOUT) {
        Ok(value) => value
            .parse::<f32>()
            .inspect(|&value| {
                if value < 0f32 {
                    panic!("{DB_CONN_TIMEOUT} should be a positive number")
                }
            })
            .map(Duration::from_secs_f32)
            .unwrap_or_else(|e| panic!("{DB_CONN_TIMEOUT} should be a float number. error: {e}")),
        Err(_) => {
            let default_value = Duration::from_secs_f32(0.5);
            tracing::debug!(
                "env var {DB_CONN_TIMEOUT} hasn't been set, using default value: {default_value:?}",
            );
            default_value
        }
    });
