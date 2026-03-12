#!/bin/sh

set -eu

# See https://github.com/actions/checkout/issues/1169
git config --system --add safe.directory "$(pwd)"

# Changing working directory to input path
cd "$INPUT_PATH"

# Run linters
if [ -z "$INPUT_FROM_REVISION" ]; then
  golangci-lint run --timeout="$INPUT_TIMEOUT" ./...
else
  golangci-lint run --timeout="$INPUT_TIMEOUT" --new-from-rev="$INPUT_FROM_REVISION" ./...
fi
