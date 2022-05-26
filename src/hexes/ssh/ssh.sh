#!/bin/bash -xe

function cmd_key_save() {
  local hex_profile="${1?'hex_profile is required'}"
  local _basedir="$(pwd)/$hex_profile"
  [[ ! -f "$_basedir/ssh-key.tar.gz.gpg" ]]
  cd "$HOME"
  [[ -d .ssh ]]
  mkdir -p "$_basedir"
  tar czf - .ssh | gpg --pinentry-mode loopback -c --armor -o "$_basedir/ssh-key.tar.gz.gpg" -
  cp .ssh/id_rsa.pub "$_basedir/id_rsa.pub"
  cd -
}

function cmd_key_load() {  
  local hex_profile="${1?'hex_profile is required'}"
  local _basedir="$(pwd)/$hex_profile"
  cd "$HOME"
  [[ ! -d .ssh ]]
  gpg --pinentry-mode loopback -d "$_basedir/ssh-key.tar.gz.gpg" | tar xz --no-same-owner -f -
  cd -
}

function cmd_mykey() {
  local hex_profile="${1?'hex_profile is required'}"
  if ! grep "$(cat "$hex_profile/id_rsa.pub" | cut -d' ' -f2)" "$HOME/.ssh/authorized_keys"; then
    mkdir -p "$HOME/.ssh"
    cat "$hex_profile/id_rsa.pub" >> "$HOME/.ssh/authorized_keys"
  fi
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"