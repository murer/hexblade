#!/bin/bash -xe

cmd_clean() {
  rm -rf /opt/vscode.tar.gz || true
  [[ ! -f /opt/vscode.tar.gz ]]
}

cmd_install() {
  cd /opt

  if [[ ! -f VSCode-linux-x64/code ]]; then
    wget --progress=dot -e dotbytes=1M -c \
      'https://go.microsoft.com/fwlink/?LinkID=620884' \
      -O vscode.tar.gz
    tar xzf vscode.tar.gz
    cmd_clean
  fi

  [[ -f /usr/local/bin/code ]] || ln -s /opt/VSCode-linux-x64/code /usr/local/bin/code

  cd -
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"

