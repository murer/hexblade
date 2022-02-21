
cmd_recipe_mem() {
  read -p 'Username: ' hexblade_recipe_user_name
  read -p 'Hostname (ubuntu to live): ' hexblade_recipe_hostname

  [[ -d /mnt/hexblade/config ]] || cmd_config
  [[ "x$hexblade_recipe_hostname" != "x" ]]
  cmd_config_hostname "$hexblade_recipe_hostname"

  cmd_struct
  findmnt /mnt/hexblade/installer || mount -t tmpfs -o size=6g tmpfs /mnt/hexblade/installer
  
  mkdir -p /mnt/hexblade/installer/boot/efi

  [[ -d /mnt/hexblade/installer/bin ]] || cmd_basesys_strap
  cmd_basesys_install
  cmd_struct_fstab 
  cmd_basesys_kernel
  cmd_keyboard

  cmd_user_add "$hexblade_recipe_user_name"
}

