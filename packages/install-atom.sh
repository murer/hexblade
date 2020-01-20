#!/bin/bash -xe

[[ "x$UID" != "x0" ]]

cd "$(dirname "$0")"
pwd

mkdir -p target

wget --progress=dot -e dotbytes=1M -c \
  'https://github.com/atom/atom/releases/latest/download/atom-amd64.deb' \
  -O target/atom-amd64.deb

if ! atom -v; then
  sudo dpkg -i target/atom-amd64.deb || true
  sudo apt-get install -f
  sudo dpkg -i target/atom-amd64.deb
fi
