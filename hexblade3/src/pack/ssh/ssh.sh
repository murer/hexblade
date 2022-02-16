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
  gpg --batch -d "$_basedir/ssh-key.tar.gz.gpg" | tar xzf -
  cd -
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
