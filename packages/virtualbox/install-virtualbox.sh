#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

rm -rf target/virtualbox || true
mkdir -p target/virtualbox

apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://www.virtualbox.org/download/oracle_vbox.asc | apt-key add -
curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | apt-key add -

echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | tee /etc/apt/sources.list.d/virtualbox.list
echo "# deb-src http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | tee -a /etc/apt/sources.list.d/virtualbox.list

apt -y update
apt-cache search virtualbox | grep ^virtualbox
apt install -y virtualbox-6.1 dkms

usermod -aG vboxusers "$USER"

# Install usb 30 support extention: https://www.virtualbox.org/wiki/Downloads
wget --progress=dot -e dotbytes=64K -c \
  -O target/virtualbox/Oracle_VM_VirtualBox_Extension_Pack.vbox-extpack \
  'https://download.virtualbox.org/virtualbox/6.1.14/Oracle_VM_VirtualBox_Extension_Pack-6.1.14.vbox-extpack'
vboxmanage extpack install \
  target/virtualbox/Oracle_VM_VirtualBox_Extension_Pack.vbox-extpack \
  --accept-license=33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c