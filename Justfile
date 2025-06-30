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
    redocly generate-arazzo ./openapi/openapi.yaml
    # run contract tests against the api server
    redocly respect auto-generated.arazzo.yaml --verbose

# generate server stubs with rust-axum generator
gen:
    sh ./scripts/gen-rust-axum.sh

# run the openapi server in debug mode
run:
    cargo run -p tt-http-app
