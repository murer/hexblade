
cmd_recipe_cryptlive() {
  [[ -f /mnt/hexblade/iso/hexblade.iso ]]
  
  #read -p 'Target device, it will be formatted (ex: /dev/sdb2): ' hexblade_recipe_dev
  #read -p 'Target device efi, it will be formatted (ex: /dev/sdb1): ' hexblade_recipe_efi
  hexblade_recipe_dev=/dev/sdb2
  hexblade_recipe_efi=/dev/sdb1


  if [[ ! -f /mnt/hexblade/loop/md5sum.txt ]]; then
    mkdir -p /mnt/hexblade/loop
    mount -o loop /mnt/hexblade/iso/hexblade.iso /mnt/hexblade/loop
  fi

  if ! ls /dev/mapper/LIVECRYPTED; then
    cmd_crypt_format "${hexblade_recipe_dev}" "LIVECRYPTED"
  fi

  if ! ls /dev/mapper/LIVEBASE-LIVEDATA; then
    cmd_lvm_format /dev/mapper/LIVECRYPTED LIVEBASE
    cmd_lvm_add LIVEBASE LIVEROOT 5G
    cmd_lvm_add LIVEBASE LIVEDATA '100%FREE'
  fi

  if ! findmnt | grep /mnt/hexblade/cryptlive; then
    mkfs.ext4 -L LIVEROOT "/dev/mapper/LIVEBASE-LIVEROOT"
    mkdir -p /mnt/hexblade/cryptlive
    mount /dev/mapper/LIVEBASE-LIVEROOT /mnt/hexblade/cryptlive
  fi

  rsync -a --delete /mnt/hexblade/loop/ /mnt/hexblade/cryptlive/

  if ! findmnt | grep /mnt/hexblade/cryptefi; then
    cmd_efi_format "$hexblade_recipe_efi"
    mkdir -p /mnt/hexblade/cryptefi
    mount "$hexblade_recipe_efi" /mnt/hexblade/cryptefi
  fi

  mkdir -p /mnt/hexblade/cryptefi/EFI/hexblade
  cp /mnt/hexblade/cryptlive/isolinux/bootx64.efi /mnt/hexblade/cryptefi/EFI/hexblade



}

