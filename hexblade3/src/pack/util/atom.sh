#!/bin/bash -xe

function cmd_install() {
  [[ "x$UID" == "x0" ]]
  
  file="$(mktemp)"
  _cleanup() {
    rm "$file" || true
  }
  trap _cleanup EXIT

  if ! atom -v --no-sandbox; then
    wget --progress=dot -e dotbytes=1M -c \
      'https://github.com/atom/atom/releases/latest/download/atom-amd64.deb' \
      -O "$file"

    dpkg -i "$file" || true
    apt install -yf
    dpkg -i "$file"
  fi
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"

