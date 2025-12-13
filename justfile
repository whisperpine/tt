# list all available subcommands
_default:
  @just --list

# --------------------------------------
# OpenAPI
# --------------------------------------

# lint OpenAPI Specifications
[group("OpenAPI")]
lint:
  redocly lint ./openapi/openapi.yaml

# generate API documentation as an HTML file
[group("OpenAPI")]
doc:
  sh ./scripts/build-docs.sh

# bundle OpenAPI Specifications in to a single file
[group("OpenAPI")]
bundle:
  redocly bundle -o ./openapi/bundled.yaml ./openapi/openapi.yaml

# run OpenAPI contract tests by Arazzo
[group("OpenAPI")]
arazzo:
  # generate test workflows from the openapi spec
  redocly generate-arazzo ./openapi/openapi.yaml -o gen.arazzo.yaml
  # run contract tests against the api server
  redocly respect gen.arazzo.yaml --verbose

# --------------------------------------
# Rust
# --------------------------------------

# generate server stubs with rust-axum generator
[group("Rust")]
gen:
  sh ./scripts/gen-rust-axum.sh

# run the openapi server in debug mode
[group("Rust")]
run:
  DB_CONN_TIMEOUT=0.5 \
  RUST_LOG="tt_http_core=debug,tt_http_app=debug" \
  cargo run -p tt-http-app

# spin up docker compose services and run the backend app
[group("Rust")]
spin-up:
  sh ./scripts/spin-up.sh

# --------------------------------------
# PostgreSQL
# --------------------------------------

# fix SQL linting errors found by sqlfluff
[group("SQL")]
fix:
  sqlfluff fix
