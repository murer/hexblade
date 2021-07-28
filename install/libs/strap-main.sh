
cmd_strap() {

  tmp_strap_mirror="br"
  [[ "x$hexblade_apt_mirror" == "x" ]] || tmp_strap_mirror="http://"$hexblade_apt_mirror".archive.ubuntu.com/ubuntu/"

  sudo debootstrap focal /mnt/hexblade/installer "$tmp_strap_mirror"

}
