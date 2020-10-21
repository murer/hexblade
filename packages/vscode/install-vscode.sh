#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

cd /opt

wget --progress=dot -e dotbytes=1M -c \
  'https://go.microsoft.com/fwlink/?LinkID=620884' \
  -O vscode.tar.gz

tar xzf vscode.tar.gz

cd -

# https://go.microsoft.com/fwlink/?LinkID=620884


# wget --progress=dot -e dotbytes=1M -c \
#   'https://go.microsoft.com/fwlink/?LinkID=760868' \
#   -O target/vscode.deb
#
# if ! code -v; then
#   dpkg -i target/vscode.deb || true
#   apt install -yf
#   dpkg -i target/vscode.deb
# fi

wget
