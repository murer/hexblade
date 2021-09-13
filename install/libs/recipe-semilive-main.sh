
cmd_recipe_semilive_efi() {
  cd /mnt/hexblade/image
  grub-mkstandalone \
   --format=x86_64-efi \
   --output=EFI/bootx64.efi \
   --locales="" \
   --fonts="part_gpt cryptodisk luks lvm ext2" \
   "boot/grub/grub.cfg=isolinux/grub.cfg"
  cd -
}

cmd_recipe_semilive_grub() {
  hexblade_recipe_root_dev="${1?'hexblade_recipe_root_dev'}"
  hexblade_crypted_id="$(sudo blkid -o value -s UUID "$hexblade_recipe_root_dev" | tr -d '-')"

  echo "
    insmod all_video
    set default=\"0\"
    set timeout=30
    menuentry \"Hexblade Encrypted Live\" {
      cryptomount -u $hexblade_crypted_id
      linux /casper/vmlinuz boot=casper nopersistent verbose nosplash ---
      initrd /casper/initrd
    }
  " | tee /mnt/hexblade/image/isolinux/grub.cfg
}

cmd_recipe_semilive() {

  read -p 'Root Partition, it will be formatted (/dev/sdb2): ' hexblade_recipe_root_dev
  read -p 'EFI Partition, it will be formatted (/dev/sdb1): ' hexblade_recipe_efi_dev

  [[ ! -d /mnt/hexblade/image ]]
  cmd_recipe_live_config

  cmd_crypt_format "$hexblade_recipe_root_dev" SEMILIVECRYPTED
  cmd_lvm_format /dev/mapper/SEMILIVECRYPTED SEMILIVE
  cmd_lvm_add SEMILIVE ROOT "5G"
  cmd_lvm_add SEMILIVE DATA '100%FREE'
  mkfs.ext4 -L SEMILIVEROOT /dev/mapper/SEMILIVE-ROOT
  mkfs.ext4 -L SEMILIVEDATA /dev/mapper/SEMILIVE-DATA
  cmd_efi_format "$hexblade_recipe_efi_dev"

  mkdir -p /mnt/hexblade/image
  mount /dev/mapper/SEMILIVE-ROOT /mnt/hexblade/image

  mkdir -p /mnt/hexblade/image/EFI
  mount "$hexblade_recipe_efi_dev" /mnt/hexblade/image/EFI

  cmd_recipe_live_system
  #cmd_recipe_live_standard

  cmd_recipe_semilive_grub "$hexblade_recipe_root_dev"

  #cmd_live_compress
  #cmd_recipe_semilive_efi
}
