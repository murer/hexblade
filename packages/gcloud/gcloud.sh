#!/bin/bash -xe

cmd_apt() {
  apt install -y apt-transport-https ca-certificates gnupg
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list
  curl "https://packages.cloud.google.com/apt/doc/apt-key.gpg" > /usr/share/keyrings/cloud.google.gpg
  #curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
  apt -y update
  apt install -y google-cloud-sdk
  gcloud config set disable_usage_reporting false
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
