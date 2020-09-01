#!/bin/bash -xe

[[ "x$UID" != "x0" ]]

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://www.virtualbox.org/download/oracle_vbox.asc | sudo apt-key add -
curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -

echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
echo "# deb-src http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee -a /etc/apt/sources.list.d/virtualbox.list

sudo apt-get -y update
sudo apt-cache search virtualbox | grep ^virtualbox
sudo apt-get install -y virtualbox-6.1 dkms

sudo usermod -aG vboxusers "$USER"
