#!/bin/bash -xe

cmd_clean() {
  rm -rf /opt/go.tar.gz || true
  [[ ! -f /opt/go.tar.gz ]]
}

cmd_install() {
  cd /opt
  if [[ ! -f go/bin/go ]]; then
    wget --progress=dot -e dotbytes=1M -c \
      'https://golang.org/dl/go1.15.3.linux-amd64.tar.gz' \
      -O go.tar.gz
    tar xzf go.tar.gz
    cmd_clean
  fi
  [[ -f /usr/local/bin/go ]] || ln -s /opt/go/bin/go /usr/local/bin/go
  cd -
}

cd "$(dirname "$0")/.."; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
