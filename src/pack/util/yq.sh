#!/bin/bash -xe

# https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-amd64

function cmd_detect_os() {
  local _ret="$(uname -s)"
  if echo "$_ret" | grep -i linux >/dev/null; then
    echo "linux"
  elif echo "$_ret" | grep -i darwin >/dev/null; then
    echo "darwin"
  fi
}

function cmd_detect_arch() {
  local _ret="$(uname -m)"
  if echo "$_ret" | grep -i x86_64 >/dev/null; then
    echo "amd64"
  elif echo "$_ret" | grep -i arm64 >/dev/null; then
    echo "arm64"
  fi
}

function cmd_install() {
  [[ "x$UID" == "x0" ]]
  
  local _os="$(cmd_detect_os)"
  [ ! -z "$_os" ]

  local _arch="$(cmd_detect_arch)"
  [ ! -z "$_arch" ]

  file="$(mktemp)"
  _cleanup() {
    rm "$file" || true
  }
  trap _cleanup EXIT

  wget --progress=dot -e dotbytes=1M -c \
    "https://github.com/jqlang/jq/releases/latest/download/jq-${_os}-${_arch}" \
    -O "$file"
  chmod +x "$file"
  "$file" -V
  cp "$file" /usr/local/bin/jq

  wget --progress=dot -e dotbytes=1M -c \
    "https://github.com/mikefarah/yq/releases/latest/download/yq_${_os}_${_arch}" \
    -O "$file"
  chmod +x "$file"
  "$file" -V
  cp "$file" /usr/local/bin/yq
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
