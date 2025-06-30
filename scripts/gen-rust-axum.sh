#!/bin/sh

# Purpose: generate server stubs with rust-axum generator
# Usage: sh path/to/gen-rust-axum.sh
# Dependencies: redocly, openapi-generator-cli, cargo fmt
# Date: 2025-06-30
# Author: Yusong

set -e

# Bundle OpenAPI Specifications in to a single file.
redocly bundle \
    -o ./openapi/bundled.yaml \
    ./openapi/openapi.yaml

package_name="tt-openapi"
output_dir="./$package_name"

# Generate server stubs with rust-axum generator.
openapi-generator-cli generate \
    --package-name $package_name \
    --output $output_dir \
    --config oasgen.yaml

## Learn more about "openapi-generator-cli generate" command.
# openapi-generator-cli help generate

# Format to generated code by cargo-fmt.
cargo fmt --package $package_name

lints='
[lints.rust]
mismatched_lifetime_syntaxes = "allow"

[lints.rustdoc]
bare_urls = "allow"

[lints.clippy]
uninlined_format_args = "allow"
'

# Add customized lints to eliminate warnings.
echo "$lints" >>./tt-openapi/Cargo.toml
