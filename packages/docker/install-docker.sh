#!/bin/bash -xe

apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" >> /etc/apt/sources.list.d/docker.list
echo "# deb-src [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" >> /etc/apt/sources.list.d/docker.list

# add-apt-repository \
#    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#    $(lsb_release -cs) \
#    stable"

apt -y update

apt install -y docker-ce docker-ce-cli containerd.io

#docker run hello-world

if [[ "x$hexblade_user" != "x" ]]; then
  usermod -aG docker "$hexblade_user"
elif [[ "x$UID" == "x0" && "x$SUDO_USER" != "x" && "x$SUDO_UID" != "x0" ]]; then
  usermod -aG docker "$SUDO_USER"
elif [[ "x$UID" != "x0" ]]; then
  usermod -aG docker "$USER"
fi
