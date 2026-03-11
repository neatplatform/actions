#!/bin/sh

set -eu

kubeconform_on_file() {
  printf "\n====================[ KUBECONFORM ]====================\n\n"
  file=$1
  kubeconform "$file"
}

kubeconform_on_dir() {
  printf "\n====================[ KUBECONFORM ]====================\n\n"
  dir=$1
  find "$dir" | grep -E "yml|yaml$" | xargs kubeconform
}

kubescore_on_file() {
  printf "\n====================[ KUBE-SCORE ]====================\n\n"
  file=$1
  kube-score score "$file"
}

kubescore_on_dir() {
  printf "\n====================[ KUBE-SCORE ]====================\n\n"
  dir=$1
  find "$dir" | grep -E "yml|yaml$" | xargs kube-score score
}

run() {
  if [ -f "$1" ]; then
    [ "$INPUT_RUN_KUBECONFORM" = "true" ] && kubeconform_on_file "$1" || true
    [ "$INPUT_RUN_KUBESCORE" = "true" ] && kubescore_on_file "$1" || true
  elif [ -d "$1" ]; then
    [ "$INPUT_RUN_KUBECONFORM" = "true" ] && kubeconform_on_dir "$1" || true
    [ "$INPUT_RUN_KUBESCORE" = "true" ] && kubescore_on_dir "$1" || true
  else
    echo "$1 is neither a file nor a directory."
    exit 1
  fi
}

run "$INPUT_PATH"
