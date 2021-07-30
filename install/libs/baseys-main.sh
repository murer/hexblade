
cmd_basesys_strap() {
  hexblade_apt_mirror="$(cat /mnt/hexblade/config/basesys/mirror.txt)"
  
  tmp_strap_mirror=""
  [[ "x$hexblade_apt_mirror" == "x" ]] || tmp_strap_mirror="http://${hexblade_apt_mirror}.archive.ubuntu.com/ubuntu/"

  sudo debootstrap focal /mnt/hexblade/installer "$tmp_strap_mirror"
}

cmd_basesys_install() {

  hexblade_apt_mirror="$(cat /mnt/hexblade/config/basesys/mirror.txt)"
  [[ "x$hexblade_apt_mirror" == "x" ]] || hexblade_apt_mirror="${hexblade_apt_mirror}."

  cp -R /mnt/hexblade/config/basesys/etc/* /mnt/hexblade/installer/etc
  sed -i -e "s/HEXBLADE_MIRROR/$hexblade_apt_mirror/g" /mnt/hexblade/installer/etc/apt/sources.list

  echo 'LANG="en_US.UTF-8"' | tee /mnt/hexblade/installer/etc/default/locale
  echo 'America/Sao_Paulo' | tee /mnt/hexblade/installer/etc/timezone

  echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean false | arch-chroot /mnt/hexblade/installer debconf-set-selections

  arch-chroot /mnt/hexblade/installer ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
  arch-chroot /mnt/hexblade/installer locale-gen en_US.UTF-8
  DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/installer dpkg-reconfigure -f non-interactive tzdata

  arch-chroot /mnt/hexblade/installer apt -y update
  DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/installer apt -y install ubuntu-standard \
    language-pack-en-base \
    software-properties-common \
    vim wget curl openssl git vim \
    nmap ncat pv zip connect-proxy tcpdump bc \
    network-manager net-tools locales # netcat debconf-utils

  echo -e "network:\n  version: 2\n  renderer: NetworkManager" | tee /mnt/hexblade/installer/etc/netplan/01-netcfg.yaml

  #DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/installer apt -y install --install-recommends linux-generic

  #if [[ "x$hexblade_dev_lvm" != "x" ]]; then
  #  arch-chroot /mnt/hexblade/installer apt -y install cryptsetup lvm2
  #fi

  if [[ -d /sys/firmware/efi ]]; then
    arch-chroot /mnt/hexblade/installer apt -y install grub-efi
  else
    arch-chroot /mnt/hexblade/installer apt -y install grub-pc
  fi

}

cmd_basesys_kernel() {
  #DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/installer apt -y install "linux-image-5.4.0-54-generic" "linux-headers-5.4.0-54-generic"
  #DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/installer apt -y install "linux-image-generic" "linux-headers-generic"
  #DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/installer apt -y install linux-generic-hwe-20.04
  DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/installer apt -y install --install-recommends linux-generic
  arch-chroot /mnt/hexblade/installer apt -y install cryptsetup lvm2 btrfs-progs
}

