#!/bin/bash -xe

function cmd_install() {
  [[ "x$UID" == "x0" ]]
  
  file="$(mktemp)"
  _cleanup() {
    rm "$file" || true
  }
  trap _cleanup EXIT

  if ! protoc --version; then
    wget --progress=dot -e dotbytes=512K -c \
      "https://github.com/protocolbuffers/protobuf/releases/download/v33.5/protoc-33.5-linux-x86_64.zip" \
      -O "$file"

    mkdir -p /opt/protobuf
    cd /opt/protobuf
    unzip "$file"
    ln -s /opt/protobuf/bin/protoc /usr/local/bin/protoc
  fi
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"

