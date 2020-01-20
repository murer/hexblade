#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

cp -R target/config/etc.pre/* /mnt/installer/etc

arch-chroot /mnt/installer ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
arch-chroot /mnt/installer locale-gen en_US.UTF-8
arch-chroot /mnt/installer dpkg-reconfigure -f non-interactive tzdata

[[ -d "/mnt/installer/home/$(cat target/config/user/user.txt)" ]] || \
  sudo arch-chroot /mnt/installer useradd -u 1000 -m -G adm,cdrom,sudo,dip,plugdev -s /bin/bash "$(cat target/config/user/user.txt)" -p "$(cat target/config/user/pass.txt)" || true

arch-chroot /mnt/installer apt-get -y update
arch-chroot /mnt/installer apt-get -y install ubuntu-standard \
  language-pack-en-base \
  software-properties-common \
  vim wget curl openssl git \
  nmap netcat pv zip connect-proxy tcpdump zip pv bc
arch-chroot /mnt/installer apt-get -y install network-manager
sudo tee /mnt/installer/etc/netplan/01-netcfg.yaml <<-EOF
network:
  version: 2
  renderer: NetworkManager
EOF
arch-chroot /mnt/installer apt-get -y install linux-image-generic linux-headers-generic
arch-chroot /mnt/installer apt-get -y install cryptsetup lvm2
arch-chroot /mnt/installer apt-get -y install grub-efi

cp -R target/config/etc.post/* /mnt/installer/etc
sudo arch-chroot /mnt/installer update-grub
sudo arch-chroot /mnt/installer grub-install /dev/sda
sudo arch-chroot /mnt/installer update-initramfs -u -k all
