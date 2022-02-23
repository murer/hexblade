#!/bin/bash -xe

function cmd_key_save() {
  local _basedir="$(pwd)"
  [[ ! -f "$_basedir/ssh-key.tar.gz.gpg" ]]
  cd "$HOME"
  [[ -d .ssh ]]
  tar czf - .ssh | gpg --batch -c --armor -o "$_basedir/ssh-key.tar.gz.gpg" -
  cd -
}

function cmd_key_load() {
  local  _basedir="$(pwd)"
  cd "$HOME"
  [[ ! -d .ssh ]]
  gpg --batch -d "$_basedir/ssh-key.tar.gz.gpg" | tar xz --no-same-owner -f -
  cd -
}

function cmd_mykey() {
  if ! grep "$(cat id_rsa.pub | cut -d' ' -f2)" "$HOME/.ssh/authorized_keys"; then
    mkdir -p "$HOME/.ssh"
    cat id_rsa.pub >> "$HOME/.ssh/authorized_keys"
  fi
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"