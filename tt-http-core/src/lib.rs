//! # tt-http-core
//!
//! This crate provides the core HTTP server functionality for the tt project.

#![cfg_attr(debug_assertions, allow(unused))]
#![cfg_attr(
    not(debug_assertions),
    deny(warnings, missing_docs),
    deny(clippy::todo, clippy::unwrap_used)
)]
#![cfg_attr(
    not(any(test, debug_assertions)),
    deny(clippy::print_stdout, clippy::dbg_macro)
)]

mod config;
mod db;
mod error;
mod server;

pub(crate) use config::{DB_CONNECTION_TIMEOUT, MAX_DB_CONNECTIONS, PKG_VERSION};
pub(crate) use db::connection_pool;
pub(crate) use error::{Error, Result};
pub(crate) use server::ServerImpl;

pub use config::CRATE_NAME;
pub use server::start_server;
