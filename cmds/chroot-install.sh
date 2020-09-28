#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

cp -R target/config/etc.pre/* /mnt/hexblade/installer/etc

arch-chroot /mnt/hexblade/installer ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
arch-chroot /mnt/hexblade/installer locale-gen en_US.UTF-8
arch-chroot /mnt/hexblade/installer dpkg-reconfigure -f non-interactive tzdata
arch-chroot /mnt/hexblade/installer dpkg-reconfigure keyboard-configuration

[[ -d "/mnt/hexblade/installer/home/$(cat target/config/user/user.txt)" ]] || \
  arch-chroot /mnt/hexblade/installer useradd -u 1000 -m -G adm,cdrom,sudo,dip,plugdev -s /bin/bash "$(cat target/config/user/user.txt)" -p "$(cat target/config/user/pass.txt)" || true

arch-chroot /mnt/hexblade/installer apt $HEXBLADE_APT_ARGS -y update || true
#arch-chroot /mnt/hexblade/installer apt $HEXBLADE_APT_ARGS -y upgrade
arch-chroot /mnt/hexblade/installer apt $HEXBLADE_APT_ARGS -y install ubuntu-standard \
  language-pack-en-base \
  software-properties-common \
  vim wget curl openssl git vim \
  nmap netcat pv zip connect-proxy tcpdump bc \
  network-manager net-tools

sudo tee /mnt/hexblade/installer/etc/netplan/01-netcfg.yaml <<-EOF
network:
  version: 2
  renderer: NetworkManager
EOF

rm -rf "/mnt/hexblade/installer/home/$(cat target/config/user/user.txt)/hexblade"
cp -R "." "/mnt/hexblade/installer/home/$(cat target/config/user/user.txt)/hexblade"
arch-chroot /mnt/hexblade/installer chown -R "$(cat target/config/user/user.txt):$(cat target/config/user/user.txt)" "/home/$(cat target/config/user/user.txt)"

arch-chroot /mnt/hexblade/installer apt $HEXBLADE_APT_ARGS -y install linux-image-generic linux-headers-generic
arch-chroot /mnt/hexblade/installer apt $HEXBLADE_APT_ARGS -y install cryptsetup lvm2
