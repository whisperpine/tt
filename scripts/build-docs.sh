#!/bin/sh

# Purpose: generate API documentation as an HTML file
# Usage: sh path/to/build-docs.sh
# Dependencies: redocly
# Date: 2025-06-29
# Author: Yusong

redocly build-docs \
    --output pages/index.html \
    openapi/openapi.yaml
