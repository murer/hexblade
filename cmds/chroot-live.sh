#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

cp -R target/config/etc.pre/* /mnt/installer/etc

arch-chroot /mnt/installer ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
arch-chroot /mnt/installer locale-gen en_US.UTF-8
arch-chroot /mnt/installer dpkg-reconfigure -f non-interactive tzdata
arch-chroot /mnt/installer dpkg-reconfigure keyboard-configuration

[[ -d "/mnt/installer/home/$(cat target/config/user/user.txt)" ]] || \
  arch-chroot /mnt/installer useradd -u 1000 -m -G adm,cdrom,sudo,dip,plugdev -s /bin/bash "$(cat target/config/user/user.txt)" -p "$(cat target/config/user/pass.txt)" || true

arch-chroot /mnt/installer apt -y update
#arch-chroot /mnt/installer apt -y upgrade
arch-chroot /mnt/installer apt -y install ubuntu-standard \
  language-pack-en-base \
  software-properties-common \
  vim wget curl openssl git vim \
  nmap netcat pv zip connect-proxy tcpdump bc \
  network-manager

sudo tee /mnt/installer/etc/netplan/01-netcfg.yaml <<-EOF
network:
  version: 2
  renderer: NetworkManager
EOF

rm -rf "/mnt/installer/home/$(cat target/config/user/user.txt)/hex"
cp -R "." "/mnt/installer/home/$(cat target/config/user/user.txt)/hex"
arch-chroot /mnt/installer chown -R "$(cat target/config/user/user.txt):$(cat target/config/user/user.txt)" "/home/$(cat target/config/user/user.txt)"

arch-chroot /mnt/installer apt -y install linux-image-generic linux-headers-generic
arch-chroot /mnt/installer apt -y install cryptsetup lvm2
