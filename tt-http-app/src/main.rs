//! # tt-http-app
//!
//! HTTP server application for the tt project.

// rustc
#![cfg_attr(debug_assertions, allow(unused))]
#![cfg_attr(not(debug_assertions), deny(missing_docs))]
#![cfg_attr(not(debug_assertions), deny(clippy::unwrap_used))]
#![cfg_attr(not(debug_assertions), deny(warnings))]
// clippy
#![cfg_attr(not(debug_assertions), deny(clippy::todo))]
#![cfg_attr(
    not(any(test, debug_assertions)),
    deny(clippy::print_stdout, clippy::dbg_macro)
)]

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    init_tracing_subscriber();
    let addr = std::net::SocketAddr::from(([0, 0, 0, 0], 8080));
    tt_http_core::start_server(addr).await;
    Ok(())
}

fn init_tracing_subscriber() {
    use tracing_subscriber::layer::SubscriberExt;
    use tracing_subscriber::util::SubscriberInitExt;

    tracing_subscriber::registry()
        .with(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| format!("{}=info", tt_http_core::CRATE_NAME).into()),
        )
        .with(tracing_subscriber::fmt::layer())
        .init();
}
