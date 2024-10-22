#!/bin/bash -xe

function cmd_version() {
  curl "https://go.dev/dl/" | grep -o '/dl/go.*linux-amd64\.tar\.gz' | head -n 1
}

function cmd_install() {
  [[ "x$UID" == "x0" ]]

  if ! go version; then
    _version="$HEXBLADE_GO_VERSION"
    [ ! -z "$_version" ] || _version="$(cmd_version)"
  
    file="$(mktemp)"
    _cleanup() {
      rm "$file" || true
    }
    trap _cleanup EXIT

    wget --progress=dot -e dotbytes=512K -c -O "$file" "https://go.dev/$_version"

    cd /opt
    tar xzf "$file"
    ln -s /opt/go/bin/go /usr/local/bin/go
    ln -s /opt/go/bin/gofmt /usr/local/bin/gofmt
    cd - 1>&2
  fi
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"

