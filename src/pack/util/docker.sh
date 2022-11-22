#!/bin/bash -xe

function cmd_group() {
  usermod -aG docker "${1?'uername'}"
}

function cmd_install() {
  apt install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common

  mkdir -p /etc/apt/hardkeys
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor > /etc/apt/hardkeys/docker.gpg

  echo "deb [arch=amd64 signed-by=/etc/apt/hardkeys/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
  echo "# deb-src [arch=amd64 signed-by=/etc/apt/hardkeys/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" >> /etc/apt/sources.list.d/docker.list

  apt -y update

  apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  
  echo '#!/bin/bash -xe' > /usr/local/bin/docker-compose 
  echo 'exec docker compose "$@"' >> /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose

  if [[ "x$hexblade_user" != "x" ]]; then
    cmd_group "$hexblade_user"
  elif [[ "x$UID" == "x0" && "x$SUDO_USER" != "x" && "x$SUDO_UID" != "x0" ]]; then
    cmd_group "$SUDO_USER"
  elif [[ "x$UID" != "x0" ]]; then
   cmd_group "$USER"
  fi
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
