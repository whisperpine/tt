//! # tt-http-core
//!
//! This crate provides the core HTTP server functionality for the tt project.

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

mod config;
mod error;
mod server;

pub use config::{CRATE_NAME, PKG_VERSION};
pub use server::start_server;

pub(crate) use error::{Error, Result};
pub(crate) use server::ServerImpl;
