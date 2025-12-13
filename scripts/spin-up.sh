#!/bin/sh

# Purpose: spin up docker compose services and run the backend app.
# Usage: sh path/to/spin-up.sh
# Dependencies: docker, rust
# Date: 2025-12-13
# Author: Yusong

set -e

# Check if "docker" is locally installed.
if ! command -v docker >/dev/null 2>&1; then
  echo "Error: Cannot find the 'docker' command. Please install docker."
  exit 1
fi

# Check if "rust toolchain" is locally installed.
if ! command -v cargo >/dev/null 2>&1; then
  echo "Error: Cannot find the 'cargo' command. Please install rust toolchain."
  exit 1
fi

# Check if the ".env" file exists under the root directory of this project.
env_file="$(git rev-parse --show-toplevel)/.env"
if [ ! -f "$env_file" ]; then
  echo "Warn: File not found '$env_file'."
  cp ./example.env ./.env
  echo "Info: A new '.env' file has been copied from 'example.env'."
fi

# Source environment variables defined in "../.env".
# shellcheck source=../.env
. "$env_file"

# A flag used to decided whether to run "docker compose down" when exiting.
tear_down_flag=0

# Make sure services defined in compose.yaml are running.
if ! docker compose ps | grep -q "tt-postgres"; then
  echo "Info: Docker compose services are not running. Starting them..."
  docker compose up -d
  echo "Info: Waiting for services to be ready..."
  sleep 1
  # Only tear down when exiting if services were not running before this script.
  tear_down_flag=1
fi

# This function should be used to handle SIGINT and SIGTERM.
graceful_shutdown() {
  if [ "$tear_down_flag" -ne 0 ]; then
    echo ""
    echo "Info: Script interrupted. Tearing down docker compose services..."
    docker compose down
  fi
  exit
}

# Run graceful_shutdown when SIGINT or SIGTERM received.
trap graceful_shutdown INT TERM

# Compile and run the rust backend application.
DB_CONN_TIMEOUT=0.5 \
  RUST_LOG="tt_http_core=debug,tt_http_app=debug" \
  DATABASE_URL="$DATABASE_URL" \
  cargo run -p tt-http-app
