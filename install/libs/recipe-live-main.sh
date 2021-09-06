
cmd_recipe_live_config() {
  [[ -d /mnt/hexblade/config ]] || cmd_config_all
  cmd_config_hostname ubuntu
  cmd_struct
}

cmd_recipe_live_system() {
  [[ -d /mnt/hexblade/installer/bin ]] || cmd_basesys_strap
  cmd_basesys_install
  cmd_struct_fstab
  cmd_basesys_kernel
  cmd_keyboard

  cmd_user_add "ubuntu" '$6$Xv604MKh3Nwhy2XI$t4U90L/uCXlzby2ndDlL4bKLTCpe93if.WXBC//QaM89QmJ3QLExXb4Wa96LPX8MudoYkx5Nq8TvlpM0ND1ry0'

  cmd_live_install
}

cmd_recipe_live_iso() {
  cmd_live_compress
  cmd_live_iso
}

cmd_recipe_live_standard() {
  cp -R ../packages /mnt/hexblade/installer/opt/
  arch-chroot /mnt/hexblade/installer /opt/packages/templates/live/live.sh install
  rm -rf /mnt/hexblade/installer/opt/packages
}

cmd_recipe_live() {
  cmd_recipe_live_config
  cmd_recipe_live_system
  cmd_recipe_live_standard
  cmd_recipe_live_iso
}

cmd_recipe_live_mem() {
  cmd_recipe_live_config

  findmnt /mnt/hexblade/installer || mount -t tmpfs -o size=6g tmpfs /mnt/hexblade/installer
  
  cmd_recipe_live_system
  cmd_recipe_live_standard
  cmd_recipe_live_iso
}