

cmd_recipe_crypt() {

  read -p 'Target device: ' hexblade_recipe_dev
  read -p 'Format (y/n): ' hexblade_recipe_format
  read -p 'EFI Partition (blank): ' hexblade_recipe_efi_part
  read -p 'Grub install device: ' hexblade_recipe_grub_dev
  read -p 'Hostname: ' hexblade_recipe_hostname
  read -p 'Username: ' hexblade_recipe_user_name
  
  [[ -d /mnt/hexblade/config ]] || cmd_config
  [[ "x$hexblade_recipe_dev" != "x" ]]
  [[ "x$hexblade_recipe_hostname" != "x" ]]
  cmd_config_hostname "$hexblade_recipe_hostname"

  if [[ "x$hexblade_recipe_format" == "xy" ]]; then
    cmd_crypt_format "$hexblade_recipe_dev" MAINCRYPTED
    mkfs.ext4 -L ROOT /dev/mapper/MAINCRYPTED
  fi
  ls /dev/mapper/MAINCRYPTED || cmd_crypt_open "$hexblade_recipe_dev"

  cmd_struct
  mount /dev/mapper/MAINCRYPTED /mnt/hexblade/installer || true

  if [[ "x$hexblade_recipe_efi_part" ]]; then
    cmd_efi_mount_if_needed "$hexblade_recipe_efi_part"
  fi
  
  [[ -d /mnt/hexblade/installer/bin ]] || cmd_basesys_strap
  cmd_basesys_install
  cmd_crypt_tab MAINCRYPTED
  cmd_struct_fstab 
  cmd_basesys_kernel
  cmd_keyboard

  cmd_user_add "$hexblade_recipe_user_name"
  
  if [[ "x$hexblade_recipe_grub_dev" != "x" ]]; then
    cmd_boot "$hexblade_recipe_grub_dev"
  fi

  #cmd_struct_umount
}

cmd_recipe_crypt_from_backup() {
  [[ ! -d /mnt/hexblade/installer ]]
  [[ -d /mnt/hexblade/backup/bin ]]
  read -p 'Target device (it will be formatted): ' hexblade_recipe_dev
  read -p 'EFI Partition (blank): ' hexblade_recipe_efi_part
  read -p 'Grub install device (blank): ' hexblade_recipe_grub_dev

  cmd_crypt_format "$hexblade_recipe_dev" MAINCRYPTED
  mkfs.ext4 -L ROOT /dev/mapper/MAINCRYPTED
  ls /dev/mapper/MAINCRYPTED || cmd_crypt_open "$hexblade_recipe_dev"

  cmd_struct
  mount /dev/mapper/MAINCRYPTED /mnt/hexblade/installer || true
 
  cmd_backup_restore

  if [[ "x$hexblade_recipe_efi_part" ]]; then
    cmd_efi_mount_if_needed "$hexblade_recipe_efi_part"
  fi
  
  cmd_crypt_tab MAINCRYPTED
  cmd_struct_fstab

  if [[ "x$hexblade_recipe_grub_dev" != "x" ]]; then
    cmd_boot "$hexblade_recipe_grub_dev"
  fi
  
  #cmd_struct_umount
}
