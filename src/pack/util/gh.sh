#!/bin/bash -xe

function cmd_install() {
  [[ "x$UID" == "x0" ]]
  
  file="$(mktemp -d)"
  _cleanup() {
    rm -rf "$file" || true
  }
  trap _cleanup EXIT

  curl -s https://api.github.com/repos/cli/cli/releases/latest | \
    jq -r '.assets[].browser_download_url' | \
    grep linux_amd64 | grep 'tar.gz$' | \
    xargs wget --progress=dot -e dotbytes=1M -c -O "$file/file.tar.gz"
  tar xzCf "$file" "$file/file.tar.gz"
  cp "$(find "$file" -name 'gh' | grep '/bin/gh$')" /usr/local/bin/gh
  chmod +x /usr/local/bin/gh

}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
