#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

set +x
source target/config/params.txt || true
set -x

cp -R target/config/etc.pre/* /mnt/hexblade/installer/etc

echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean false | arch-chroot /mnt/hexblade/installer debconf-set-selections

arch-chroot /mnt/hexblade/installer ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
arch-chroot /mnt/hexblade/installer locale-gen en_US.UTF-8
arch-chroot /mnt/hexblade/installer dpkg-reconfigure -f non-interactive tzdata
arch-chroot /mnt/hexblade/installer dpkg-reconfigure keyboard-configuration

[[ -d "/mnt/hexblade/installer/home/$hexblade_user" ]] || \
  arch-chroot /mnt/hexblade/installer useradd -u 1000 -m -G adm,cdrom,sudo,dip,plugdev -s /bin/bash "$hexblade_user" -p "$hexblade_pass" || true

arch-chroot /mnt/hexblade/installer apt -y update || true
#arch-chroot /mnt/hexblade/installer apt -y upgrade
arch-chroot /mnt/hexblade/installer apt -y install ubuntu-standard \
  language-pack-en-base \
  software-properties-common \
  vim wget curl openssl git vim \
  nmap netcat pv zip connect-proxy tcpdump bc \
  network-manager net-tools locales debconf-utils

sudo tee /mnt/hexblade/installer/etc/netplan/01-netcfg.yaml <<-EOF
network:
  version: 2
  renderer: NetworkManager
EOF

rm -rf "/mnt/hexblade/installer/home/$hexblade_user/hexblade"
cp -R "." "/mnt/hexblade/installer/home/$hexblade_user/hexblade"
rm -rf "/mnt/hexblade/installer/home/$hexblade_user/hexblade/target"

arch-chroot /mnt/hexblade/installer chown -R "$hexblade_user:$hexblade_user" "/home/$hexblade_user"

DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/installer apt -y install "linux-image-5.4.0-54-generic" "linux-headers-5.4.0-54-generic"

arch-chroot /mnt/hexblade/installer apt -y install cryptsetup lvm2
