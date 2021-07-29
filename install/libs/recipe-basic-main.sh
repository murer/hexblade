
cmd_recipe_basic() {

  read -p 'Target device: ' hexblade_recipe_dev
  read -p 'Format (y/n): ' hexblade_recipe_format
  read -p 'Grub install device: ' hexblade_recipe_grub_dev
  read -p 'Username: ' hexblade_recipe_user_name
  
  [[ -d /mnt/hexblade/config ]] || cmd_config
  [[ "x$hexblade_recipe_dev" != "x" ]]

  if [[ "x$hexblade_recipe_format" == "xy" ]]; then
    mkfs.ext4 -L ROOT "$hexblade_recipe_dev"
  fi

  cmd_struct
  mount "$hexblade_recipe_dev" /mnt/hexblade/installer || true

  if [[ "x$hexblade_recipe_grub_dev" ]]; then
    cmd_efi_mount_if_needed "$hexblade_recipe_grub_dev"
  fi
  
  [[ -d /mnt/hexblade/installer/bin ]] || cmd_basesys_strap
  cmd_basesys_install
  cmd_struct_fstab 
  cmd_basesys_kernel
  cmd_keyboard

  cmd_user_add "$hexblade_recipe_user_name"

  cmd_boot "$hexblade_recipe_grub_dev"

  # cmd_struct_umount
}