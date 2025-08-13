# ======================================
# OpenAPI
# ======================================

# lint OpenAPI Specifications
lint:
  redocly lint ./openapi/openapi.yaml

# generate API documentation as an HTML file
doc:
  sh ./scripts/build-docs.sh

# bundle OpenAPI Specifications in to a single file
bundle:
  redocly bundle -o ./openapi/bundled.yaml ./openapi/openapi.yaml

# run OpenAPI contract tests by Arazzo
arazzo:
  # generate test workflows from the openapi spec
  redocly generate-arazzo ./openapi/openapi.yaml -o gen.arazzo.yaml
  # run contract tests against the api server
  redocly respect gen.arazzo.yaml --verbose


# ======================================
# Rust
# ======================================

# generate server stubs with rust-axum generator
gen:
  sh ./scripts/gen-rust-axum.sh

# run the openapi server in debug mode
run:
  DB_CONN_TIMEOUT=0.5 \
  RUST_LOG="tt_http_core=debug,tt_http_app=debug" \
  cargo run -p tt-http-app

# build the docker image for the local machine's platform
build:
  docker build -t tt-http-app .

# build multi-platform docker images (linux/amd64,linux/arm64)
buildp:
  docker build \
    --platform linux/amd64,linux/arm64 \
    -t tt-http-app \
    .


# ======================================
# PostgreSQL
# ======================================

# fix SQL linting errors found by sqlfluff
fix:
  sqlfluff fix
