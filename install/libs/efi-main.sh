
cmd_efi_mount() {
  hexblade_efi_dev="${1?'hexblade_efi_dev is required'}"
  mkdir -p /mnt/hexblade/installer/boot/efi
  mount "$hexblade_efi_dev" /mnt/hexblade/installer/boot/efi
}