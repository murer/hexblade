
cmd_recipe_live() {
  
  [[ -d /mnt/hexblade/config ]] || cmd_config

  cmd_struct
  # findmnt /mnt/hexblade/installer || mount -t tmpfs -o size=6g tmpfs /mnt/hexblade/installer
  # mkdir -p /mnt/hexblade/installer/boot/efi

  [[ -d /mnt/hexblade/installer/bin ]] || cmd_basesys_strap
  cmd_basesys_install
  cmd_struct_fstab 
  cmd_basesys_kernel
  cmd_keyboard

  cmd_user_add "ubuntu"

  cmd_live_install
  cmd_live_compress
  cmd_live_iso

}
