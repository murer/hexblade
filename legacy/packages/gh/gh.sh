#!/bin/bash -xe

cmd_clean() {
  rm -rf target || true
  [[ ! -d target ]]
}

cmd_install() {
  [[ "x$UID" == "x0" ]]
  
  mkdir -p target

  wget --progress=dot -e dotbytes=1M -c \
    'https://github.com/cli/cli/releases/download/v1.7.0/gh_1.7.0_linux_386.tar.gz' \
    -O target/gh.tar.gz

  cd target
  tar xzf gh.tar.gz
  cp ./gh_1.7.0_linux_386/bin/gh /usr/local/bin
  cd -
  
  cmd_clean
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
