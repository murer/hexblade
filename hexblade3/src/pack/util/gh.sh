#!/bin/bash -xe

function cmd_install() {
  [[ "x$UID" == "x0" ]]
  
  file="$(mktemp)"
  _cleanup() {
    rm "$file" || true
  }
  trap _cleanup EXIT

  wget --progress=dot -e dotbytes=1M -c \
    'https://github.com/cli/cli/releases/download/v1.7.0/gh_1.7.0_linux_386.tar.gz' \
    -O "$file"

  tar xzOf "$file" gh_1.7.0_linux_386/bin/gh > /usr/local/bin/gh
  chmod +x /usr/local/bin/gh
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
