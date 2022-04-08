#!/bin/bash -xe

function cmd_install() {
  [[ "x$UID" == "x0" ]]
  
  file="$(mktemp)"
  _cleanup() {
    rm "$file" || true
  }
  trap _cleanup EXIT

  if ! node --version; then
    hex_filename="$(curl 'https://nodejs.org/dist/latest/SHASUMS256.txt' | grep linux-x64.tar.gz | cut -b66- | tr -d ' ')"
    wget --progress=dot -e dotbytes=1M -c \
      "https://nodejs.org/dist/latest/$hex_filename" \
      -O "$file"

    cd /opt
    tar xzf "$file"
    mv node-v* node
    ln -s /opt/node/bin/node /usr/local/bin/node
    ln -s /opt/node/bin/npm /usr/local/bin/npm
    ln -s /opt/node/bin/npx /usr/local/bin/npx
    ln -s /opt/node/bin/corepack /usr/local/bin/corepack
  fi
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"

