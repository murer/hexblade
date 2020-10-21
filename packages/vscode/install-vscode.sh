#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

cd /opt

if [[ ! -f VSCode-linux-x64/code ]]; then
  wget --progress=dot -e dotbytes=1M -c \
    'https://go.microsoft.com/fwlink/?LinkID=620884' \
    -O vscode.tar.gz
  tar xzf vscode.tar.gz
  rm vscode.tar.gz
fi

[[ -f /usr/local/bin/code ]] || ln -s /opt/VSCode-linux-x64/code /usr/local/bin/code

cd -
