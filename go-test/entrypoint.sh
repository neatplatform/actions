#!/bin/sh

set -eu

# Changing working directory to input path
cd "$INPUT_PATH"

# Run go test command ...
go test \
  -timeout "$INPUT_TIMEOUT" \
  -race \
  -cover \
  -covermode=atomic \
  -coverprofile=coverage.out ./...

# Run if codecov_token input is set
[ -n "$INPUT_CODECOV_TOKEN" ] && codecov -f coverage.out -t "$INPUT_CODECOV_TOKEN"

# Generate HTML coverage report
go tool cover -html=coverage.out -o coverage.html

# Set action output parameters
echo "coverage_profile_file=coverage.out" >> "$GITHUB_OUTPUT"
echo "coverage_report_file=coverage.html" >> "$GITHUB_OUTPUT"
