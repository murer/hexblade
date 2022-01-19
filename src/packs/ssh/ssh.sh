#!/bin/bash -xe

cmd_enc() {
  _basedir="$(pwd)"
  [[ ! -f "$_basedir/ssh-key.tar.gz.pgp" ]]
  cd "$HOME"
  [[ -d .ssh ]]
  tar czf - .ssh | gpg --batch -c --armor -o "$_basedir/ssh-key.tar.gz.gpg" -
  cd -
}

cmd_dec() {
  _basedir="$(pwd)"
  cd "$HOME"
  [[ ! -d .ssh ]]
  gpg --batch -d "$_basedir/ssh-key.tar.gz.gpg" | tar xzf -
  cd -
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
