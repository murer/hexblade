
cmd_strap() {
  sudo mkdir -p /mnt/hexblade/installer

  hexblade_apt_mirror="br"
  
  tmp_strap_mirror=""
  [[ "x$hexblade_apt_mirror" == "x" ]] || tmp_strap_mirror="http://${hexblade_apt_mirror}.archive.ubuntu.com/ubuntu/"

  sudo debootstrap focal /mnt/hexblade/installer "$tmp_strap_mirror"

}

cmd_chroot_first() {

  cp -R config/etc.pre/* /mnt/hexblade/installer/etc

  echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean false | arch-chroot /mnt/hexblade/installer debconf-set-selections

  arch-chroot /mnt/hexblade/installer ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
  arch-chroot /mnt/hexblade/installer locale-gen en_US.UTF-8
  arch-chroot /mnt/hexblade/installer dpkg-reconfigure -f non-interactive tzdata
  #arch-chroot /mnt/hexblade/installer dpkg-reconfigure keyboard-configuration

  arch-chroot /mnt/hexblade/installer apt -y update || true
  #arch-chroot /mnt/hexblade/installer apt -y upgrade
  DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/installer apt -y install ubuntu-standard \
    language-pack-en-base \
    software-properties-common \
    vim wget curl openssl git vim \
    nmap ncat pv zip connect-proxy tcpdump bc \
    network-manager net-tools locales \
    linux-generic # netcat debconf-utils

echo "
network:
  version: 2
  renderer: NetworkManager
" | tee /mnt/hexblade/installer/etc/netplan/01-netcfg.yaml

  #DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/installer apt -y install "linux-image-5.4.0-54-generic" "linux-headers-5.4.0-54-generic"
  #DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/installer apt -y install "linux-image-generic" "linux-headers-generic"
  #DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/installer apt -y install linux-generic-hwe-20.04
  #DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/installer apt -y install --install-recommends linux-generic

  #if [[ "x$hexblade_dev_lvm" != "x" ]]; then
  #  arch-chroot /mnt/hexblade/installer apt -y install cryptsetup lvm2
  #fi

}

cmd_chroot_init() {
  cmd_strap
  cmd_chroot_first
}
