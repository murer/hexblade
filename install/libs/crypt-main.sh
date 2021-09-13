
cmd_crypt_format() {
  hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
  hexblade_crypt_name="${2?'hexblade_crypt_name'}" # MAINCRYPTED
  if ls "/dev/mapper/$hexblade_crypt_name"; then false; fi
  cryptsetup -v -y --type luks1 --cipher aes-xts-plain64 --hash sha256 luksFormat "$hexblade_crypt_dev"
  cmd_crypt_open "$hexblade_crypt_dev" "$hexblade_crypt_name"
}

cmd_crypt_open() {
  hexblade_crypt_dev="${1?'hexblade_dev_crypt is required'}"
  hexblade_crypt_name="${2?'hexblade_crypt_name'}" # MAINCRYPTED
  if ls "/dev/mapper/$hexblade_crypt_name"; then false; fi
  cryptsetup open "$hexblade_crypt_dev" "$hexblade_crypt_name"
  
  mkdir -p /mnt/hexblade/config/crypt
  echo "$hexblade_crypt_dev" > "/mnt/hexblade/config/crypt/$hexblade_crypt_name.dev"
}

cmd_crypt_tab() {
  hexblade_crypt_dev="$(cat /mnt/hexblade/config/crypt/MAINCRYPTED.dev)"
  [[ "x$hexblade_crypt_dev" != "x" ]]
  hexblade_crypt_id="$(blkid -o value -s UUID "$hexblade_crypt_dev")"
  echo -e "MAINCRYPTED\tUUID=$hexblade_crypt_id\tnone\tluks" | tee /mnt/hexblade/installer/etc/crypttab
  echo 'GRUB_ENABLE_CRYPTODISK=y' | tee /mnt/hexblade/installer/etc/default/grub.d/hexblade-crypt.cfg
}

cmd_crypt_format_with_file() {
  [[ -d /mnt/hexblade/secrets ]]
  hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
  hexblade_crypt_name="${2?'hexblade_crypt_name is required'}"
  if ls "/dev/mapper/$hexblade_crypt_name"; then false; fi
  mkdir -p /mnt/hexblade/secrets/parts
  dd if=/dev/urandom "of=/mnt/hexblade/secrets/parts/key-$hexblade_crypt_name.key" count=4 bs=512
  cryptsetup -v -y --type luks1 --cipher aes-xts-plain64 --hash sha256 luksFormat --key-file "/mnt/hexblade/secrets/parts/key-$hexblade_crypt_name.key" "$hexblade_crypt_dev"
  blkid -o value -s UUID "$hexblade_crypt_dev" | tee "/mnt/hexblade/secrets/parts/id-$hexblade_crypt_name.id"
  cmd_crypt_open_with_file "$hexblade_crypt_dev" "$hexblade_crypt_name"
}

cmd_crypt_open_with_file() {
  hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
  hexblade_crypt_name="${2?'hexblade_crypt_name is required'}"
  if ls "/dev/mapper/$hexblade_crypt_name"; then false; fi
  cryptsetup open --key-file "/mnt/hexblade/secrets/parts/key-$hexblade_crypt_name.key" "$hexblade_crypt_dev" "$hexblade_crypt_name"
}

cmd_crypt_initramfs() {
  find /mnt/hexblade/secrets/parts -name 'id-*.id' | head -n 1 | while read k; do
    cp -vR resources/crypt/initramfs-tools/* /mnt/hexblade/installer/usr/share/initramfs-tools
  done
}

cmd_crypt_localsync() {
  hexblade_local_root_dev="${1?'hexblade_local_root_dev is required'}"
  hexblade_local_root_id="$(blkid -o value -s UUID "$hexblade_local_root_dev")"
  sed -e "s/HEXBLADE_LOCALSYNC_ID/$hexblade_local_root_id/g" resources/crypt/grub.d/08_localsync | tee /mnt/hexblade/installer/etc/grub.d/08_localsync
  chmod +x /mnt/hexblade/installer/etc/grub.d/08_localsync

  (echo -e "UUID=$hexblade_local_root_id\t/\text4\trw,relatime\t0\t0" &&
  genfstab -U /mnt/hexblade/installer | grep ^UUID= | grep -v '/boot/efi' | tail -n +2) | tee /mnt/hexblade/installer/etc/fstab.localsync

  # mkdir -p /mnt/hexblade/localsync
  # mount "$hexblade_local_root_dev" /mnt/hexblade/localsync
  # rsync -a --delete  /mnt/hexblade/installer/ /mnt/hexblade/localsync/
}
