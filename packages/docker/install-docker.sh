#!/bin/bash -xe

cmd_group() {
  usermod -aG docker "${1?'uername'}"

}

cmd_install() {
  apt install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

  echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" >> /etc/apt/sources.list.d/docker.list
  echo "# deb-src [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" >> /etc/apt/sources.list.d/docker.list

  apt -y update

  apt install -y docker-ce docker-ce-cli containerd.io

  if [[ "x$hexblade_user" != "x" ]]; then
    cmd_group "$hexblade_user"
  elif [[ "x$UID" == "x0" && "x$SUDO_USER" != "x" && "x$SUDO_UID" != "x0" ]]; then
    cmd_group "$SUDO_USER"
  elif [[ "x$UID" != "x0" ]]; then
   cmd_group "$USER"
  fi
}

cd "$(dirname "$0")/.."; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
