
cmd_recipe_mem() {

  #read -p 'Target device: ' hexblade_recipe_dev
  #read -p 'Format (y/n): ' hexblade_recipe_format
  #read -p 'EFI Partition (blank): ' hexblade_recipe_efi_part
  #read -p 'Grub install device (blank): ' hexblade_recipe_grub_dev
  read -p 'Username: ' hexblade_recipe_user_name
  
  [[ -d /mnt/hexblade/config ]] || cmd_config
  #[[ "x$hexblade_recipe_dev" != "x" ]]

  #if [[ "x$hexblade_recipe_format" == "xy" ]]; then
  #  mkfs.ext4 -L ROOT "$hexblade_recipe_dev"
  #fi

  cmd_struct
  findmnt /mnt/hexblade/installer || mount -t tmpfs -o size=6g tmpfs /mnt/hexblade/installer
  
  mkdir -p /mnt/hexblade/installer/boot/efi

  #if [[ "x$hexblade_recipe_efi_part" ]]; then
  #  cmd_efi_mount_if_needed "$hexblade_recipe_efi_part"
  #fi
  
  [[ -d /mnt/hexblade/installer/bin ]] || cmd_basesys_strap
  cmd_basesys_install
  cmd_struct_fstab 
  cmd_basesys_kernel
  cmd_keyboard

  cmd_user_add "$hexblade_recipe_user_name"

  #if [[ "x$hexblade_recipe_grub_dev" != "x" ]]; then
  #  cmd_boot "$hexblade_recipe_grub_dev"
  #fi

  # cmd_struct_umount
}
