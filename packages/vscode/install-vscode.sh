#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

mkdir -p target

wget --progress=dot -e dotbytes=1M -c \
  'https://go.microsoft.com/fwlink/?LinkID=760868' \
  -O target/vscode.deb

# if ! atom -v; then
#   dpkg -i target/atom-amd64.deb || true
#   apt install -yf
#   dpkg -i target/atom-amd64.deb
# fi
