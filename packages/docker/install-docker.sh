#!/bin/bash -xe

apt $HEXBLADE_APT_ARGS install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt $HEXBLADE_APT_ARGS -y update

apt $HEXBLADE_APT_ARGS install -y docker-ce docker-ce-cli containerd.io

docker run hello-world

if [[ "x$UID" == "x0" && "x$SUDO_USER" != "x" && "x$SUDO_UID" != "x0" ]]; then
  usermod -aG docker "$SUDO_USER"
elif [[ "x$UID" != "x0" ]]; then
  usermod -aG docker "$USER"
fi
