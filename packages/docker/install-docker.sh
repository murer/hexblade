#!/bin/bash -xe

sudo apt $HEXBLADE_APT_ARGS install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt $HEXBLADE_APT_ARGS -y update

sudo apt $HEXBLADE_APT_ARGS install -y docker-ce docker-ce-cli containerd.io

sudo docker run hello-world

if [[ "x$UID" == "x0" && "x$SUDO_USER" != "x" && "x$SUDO_UID" != "x0" ]]; then
  sudo usermod -aG docker "$SUDO_USER"
elif [[ "x$UID" != "x0" ]]; then
  sudo usermod -aG docker "$USER"
fi
