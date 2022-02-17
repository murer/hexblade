
cmd_mount() {
  local hexblade_efi_dev="${1?'hexblade_efi_dev is required'}"
  [[ -d /mnt/hexblade/installer/boot ]]
  [[ ! -d /mnt/hexblade/installer/boot/efi ]]
  mkdir /mnt/hexblade/installer/boot/efi
  mount "$hexblade_efi_dev" /mnt/hexblade/installer/boot/efi
}

# cmd_mount_if_needed() {
#   if [[ -d /sys/firmware/efi ]]; then
#     cmd_efi_mount "$@"
#   fi
# }

cmd_format() {
  local hexblade_efi_dev="${1?'hexblade_efi_dev is required'}"
  mkfs.fat -n ESP -F32 "$hexblade_efi_dev"
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"