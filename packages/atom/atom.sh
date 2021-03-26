#!/bin/bash -xe

cmd_clean() {
  rm -rf target || true
  [[ ! -d target ]]
}

cmd_install() {
  [[ "x$UID" == "x0" ]]
  
  mkdir -p target

  wget --progress=dot -e dotbytes=1M -c \
    'https://github.com/atom/atom/releases/latest/download/atom-amd64.deb' \
    -O target/atom-amd64.deb

  if ! atom -v; then
    dpkg -i target/atom-amd64.deb || true
    apt install -yf
    dpkg -i target/atom-amd64.deb
  fi
  cmd_clean
}

cd "$(dirname "$0")/.."; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"

