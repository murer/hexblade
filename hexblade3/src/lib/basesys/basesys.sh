#!/bin/bash -e

function cmd_strap() {
  hexblade_apt_mirror="${1}"
  
  tmp_strap_mirror=""
  [[ "x$hexblade_apt_mirror" == "x" ]] || tmp_strap_mirror="http://${hexblade_apt_mirror}.archive.ubuntu.com/ubuntu/"

  sudo debootstrap focal /mnt/hexblade/system "$tmp_strap_mirror"
}

function cmd_base() {
  cp -R etc/* /mnt/hexblade/system/etc
  echo 'LANG="en_US.UTF-8"' | tee /mnt/hexblade/system/etc/default/locale
  echo 'America/Sao_Paulo' | tee /mnt/hexblade/system/etc/timezone

  echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean false | arch-chroot /mnt/hexblade/system debconf-set-selections

  arch-chroot /mnt/hexblade/system ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
  arch-chroot /mnt/hexblade/system locale-gen en_US.UTF-8
  DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/system dpkg-reconfigure -f non-interactive tzdata

  arch-chroot /mnt/hexblade/system apt -y update
  DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/system apt -y install ubuntu-standard \
    language-pack-en-base \
    software-properties-common \
    vim wget curl openssl git vim \
    nmap ncat pv zip connect-proxy tcpdump bc \
    network-manager net-tools locales \
    cryptsetup lvm2 btrfs-progs # netcat debconf-utils

  echo -e "network:\n  version: 2\n  renderer: NetworkManager" | tee /mnt/hexblade/system/etc/netplan/01-netcfg.yaml

  if [[ -d /sys/firmware/efi ]]; then
    arch-chroot /mnt/hexblade/system apt -y install grub-efi
  else
    arch-chroot /mnt/hexblade/system apt -y install grub-pc
  fi
  echo 'GRUB_CMDLINE_LINUX_DEFAULT="verbose nosplash"' > /mnt/hexblade/system/etc/default/grub.d/hexblade-linux-cmdline.cfg  
}

function cmd_kernel() {
  #DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/system apt -y install "linux-image-5.4.0-54-generic" "linux-headers-5.4.0-54-generic"
  #DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/system apt -y install "linux-image-generic" "linux-headers-generic"
  #DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/system apt -y install linux-generic-hwe-20.04
  DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/system apt -y install --install-recommends linux-generic
  # arch-chroot /mnt/hexblade/system apt -y install cryptsetup lvm2 btrfs-progs
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"