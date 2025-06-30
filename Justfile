# lint OpenAPI Specifications
lint:
    redocly lint ./openapi/openapi.yaml

# generate API documentation as an HTML file
doc:
    sh ./scripts/build-docs.sh

# bundle OpenAPI Specifications in to a single file
bundle:
    redocly bundle -o ./openapi/bundled.yaml ./openapi/openapi.yaml

# generate server stubs with rust-axum generator
gen:
    sh ./scripts/gen-rust-axum.sh
