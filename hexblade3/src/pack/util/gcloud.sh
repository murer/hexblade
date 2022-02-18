#!/bin/bash -xe

function cmd_install() {
  apt install -y apt-transport-https ca-certificates gnupg
  mkdir -p /etc/apt/hardkeys
  curl "https://packages.cloud.google.com/apt/doc/apt-key.gpg" > /etc/apt/hardkeys/cloud.google.gpg
  echo "deb [signed-by=/etc/apt/hardkeys/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list
  apt -y update
  apt install -y google-cloud-sdk
  if [[ "x$SUDO_USER" == "x" ]]; then
    gcloud config set disable_usage_reporting false
  else
    sudo -u "$SUDO_USER" gcloud config set disable_usage_reporting false
  fi
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
