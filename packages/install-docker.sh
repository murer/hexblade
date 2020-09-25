#!/bin/bash -xe

sudo apt $hexblade_apt_argsinstall -y \
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

sudo apt $hexblade_apt_args-y update

sudo apt $hexblade_apt_argsinstall -y docker-ce docker-ce-cli containerd.io

sudo docker run hello-world

[[ "x$UID" != "x0" ]] && sudo usermod -aG docker "$USER"
