#!/bin/bash -xe

function cmd_master() {
  [[ ! -f /mnt/hexblade/crypt/master.key ]]
  mkdir -p /mnt/hexblade/crypt
  dd if=/dev/urandom "of=/mnt/hexblade/crypt/master.key" count=4 bs=512
}

function cmd_dump() {
  local hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
  cryptsetup luksDump "$hexblade_crypt_dev"
}

function cmd_close() {
  local hexblade_crypt_name="${1?'hexblade_crypt_name'}" # MAINCRYPTED
  cryptsetup close "$hexblade_crypt_name"
}


function cmd_open() {
  local hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
  local hexblade_crypt_name="${2?'hexblade_crypt_name is required'}"
  if ls "/dev/mapper/$hexblade_crypt_name"; then false; fi
  cryptsetup open --key-file /mnt/hexblade/crypt/master.key "$hexblade_crypt_dev" "$hexblade_crypt_name"
}

function cmd_format() {
  [[ -f /mnt/hexblade/crypt/master.key ]]
  local hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
  cryptsetup -v -q -y --type luks1 --cipher aes-xts-plain64 --hash sha256 luksFormat --key-file /mnt/hexblade/crypt/master.key "$hexblade_crypt_dev"
  cryptsetup luksAddKey "$hexblade_crypt_dev"
}


# function cmd_format_with_password() {
#   local hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
#   local hexblade_crypt_name="${2?'hexblade_crypt_name'}" # MAINCRYPTED
#   if ls "/dev/mapper/$hexblade_crypt_name"; then false; fi
#   cryptsetup -v -y --type luks1 --cipher aes-xts-plain64 --hash sha256 luksFormat "$hexblade_crypt_dev"
#   cmd_crypt_open "$hexblade_crypt_dev" "$hexblade_crypt_name"
# }

# function cmd_crypt_open() {
#   local hexblade_crypt_dev="${1?'hexblade_dev_crypt is required'}"
#   local hexblade_crypt_name="${2?'hexblade_crypt_name'}" # MAINCRYPTED
#   if ls "/dev/mapper/$hexblade_crypt_name"; then false; fi
#   cryptsetup open "$hexblade_crypt_dev" "$hexblade_crypt_name"
# }

# function cmd_crypt_tab() {
#   local hexblade_crypt_name="${1?'hexblade_crypt_name'}" # MAINCRYPTED  
#   local hexblade_crypt_dev="$(cat "/mnt/hexblade/config/crypt/$hexblade_crypt_name.dev")"
#   [[ "x$hexblade_crypt_dev" != "x" ]]
#   local hexblade_crypt_id="$(blkid -o value -s UUID "$hexblade_crypt_dev")"
#   echo -e "$hexblade_crypt_name\tUUID=$hexblade_crypt_id\tnone\tluks" | tee /mnt/hexblade/installer/etc/crypttab
#   echo 'GRUB_ENABLE_CRYPTODISK=y' | tee /mnt/hexblade/installer/etc/default/grub.d/hexblade-crypt.cfg
# }


# function cmd_crypt_open_with_file() {
#   hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
#   hexblade_crypt_name="${2?'hexblade_crypt_name is required'}"
#   if ls "/dev/mapper/$hexblade_crypt_name"; then false; fi
#   cryptsetup open --key-file "/mnt/hexblade/secrets/parts/key-$hexblade_crypt_name.key" "$hexblade_crypt_dev" "$hexblade_crypt_name"
# }

# function cmd_crypt_initramfs() {
#   find /mnt/hexblade/secrets/parts -name 'id-*.id' | head -n 1 | while read k; do
#     cp -vR resources/crypt/initramfs-tools/* /mnt/hexblade/installer/usr/share/initramfs-tools
#   done
# }

# function cmd_crypt_localsync() {
#   hexblade_local_root_dev="${1?'hexblade_local_root_dev is required'}"
#   hexblade_local_root_id="$(blkid -o value -s UUID "$hexblade_local_root_dev")"
#   sed -e "s/HEXBLADE_LOCALSYNC_ID/$hexblade_local_root_id/g" resources/crypt/grub.d/08_localsync | tee /mnt/hexblade/installer/etc/grub.d/08_localsync
#   chmod +x /mnt/hexblade/installer/etc/grub.d/08_localsync

#   (echo -e "UUID=$hexblade_local_root_id\t/\text4\trw,relatime\t0\t0" &&
#   genfstab -U /mnt/hexblade/installer | grep ^UUID= | grep -v '/boot/efi' | tail -n +2) | tee /mnt/hexblade/installer/etc/fstab.localsync

#   # mkdir -p /mnt/hexblade/localsync
#   # mount "$hexblade_local_root_dev" /mnt/hexblade/localsync
#   # rsync -a --delete  /mnt/hexblade/installer/ /mnt/hexblade/localsync/
# }

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"