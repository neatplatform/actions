#!/bin/sh

set -eu

cd "$INPUT_PATH"

terraform init ${INPUT_INIT_ARGS}
terraform "$@"
