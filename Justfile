# lint OpenAPI Specifications
lint:
    redocly lint openapi/openapi.yaml

# generate API documentation as an HTML file
doc:
    sh ./scripts/build-docs.sh
