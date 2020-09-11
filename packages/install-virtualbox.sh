#!/bin/bash -xe

[[ "x$UID" != "x0" ]]

cd "$(dirname "$0")"
pwd

rm -rf target/virtualbox || true
mkdir -p target/virtualbox

sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://www.virtualbox.org/download/oracle_vbox.asc | sudo apt-key add -
curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -

echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
echo "# deb-src http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee -a /etc/apt/sources.list.d/virtualbox.list

sudo apt -y update
sudo apt-cache search virtualbox | grep ^virtualbox
sudo apt install -y virtualbox-6.1 dkms

sudo usermod -aG vboxusers "$USER"

# Install usb 30 support extention: https://www.virtualbox.org/wiki/Downloads
wget --progress=dot -e dotbytes=64K -c \
  -O target/virtualbox/Oracle_VM_VirtualBox_Extension_Pack.vbox-extpack \
  'https://download.virtualbox.org/virtualbox/6.1.14/Oracle_VM_VirtualBox_Extension_Pack-6.1.14.vbox-extpack'
sudo vboxmanage extpack install ~/Downloads/Oracle_VM_VirtualBox_Extension_Pack.vbox-extpack
