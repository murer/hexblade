#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

cd /opt

if [[ ! -f go/bin/go ]]; then
  wget --progress=dot -e dotbytes=1M -c \
    'https://golang.org/dl/go1.15.3.linux-amd64.tar.gz' \
    -O go.tar.gz
  tar xzf go.tar.gz
  rm go.tar.gz
fi

[[ -f /usr/local/bin/go ]] || ln -s /opt/go/bin/go /usr/local/bin/go

cd -
