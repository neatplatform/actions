#!/bin/sh

set -eu

cd "$INPUT_PATH"

terraform init
terraform "$@"
