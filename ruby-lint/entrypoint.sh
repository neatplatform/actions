#!/bin/sh

set -eu

# Changing working directory to input path
cd "$INPUT_PATH"

# Run linter
rubocop
