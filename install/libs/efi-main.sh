
cmd_efi_mount() {
  hexblade_efi_dev="${1?'hexblade_efi_dev is required'}"
  mkdir -p /mnt/hexblade/installer/boot/efi
  mount "$hexblade_efi_dev" /mnt/hexblade/installer/boot/efi
}

cmd_efi_mount_if_needed() {
  if [[ -d /sys/firmware/efi ]]; then
    cmd_efi_mount "$@"
  fi
}