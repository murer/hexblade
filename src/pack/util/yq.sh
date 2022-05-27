#!/bin/bash -xe

function cmd_install() {
  [[ "x$UID" == "x0" ]]
  
  file="$(mktemp)"
  _cleanup() {
    rm "$file" || true
  }
  trap _cleanup EXIT

  wget --progress=dot -e dotbytes=1M -c \
    'https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64' \
    -O "$file"

  cp "$file" /usr/local/bin/yq
  chmod +x /usr/local/bin/yq
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
