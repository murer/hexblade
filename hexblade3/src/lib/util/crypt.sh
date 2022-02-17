#!/bin/bash -xe

function cmd_key_check() {
  local hexblade_crypt_key="${1?'keyname'}"
  if [[ ! -f "/mnt/hexblade/crypt/$hexblade_crypt_key.key" ]]; then
    echo "Use: $0 key_gen \"$hexblade_crypt_key\""
    false
  fi
}

function cmd_key_gen() {
  local hexblade_crypt_key="${1?'keyname'}"
  [[ ! -f "/mnt/hexblade/crypt/$hexblade_crypt_key.key" ]]
  mkdir -p /mnt/hexblade/crypt
  dd if=/dev/urandom "of=/mnt/hexblade/crypt/$hexblade_crypt_key.key" count=4 bs=512
  chmod -R 0400 /mnt/hexblade/crypt
}

function cmd_key_load() {
  [[ -d /mnt/hexblade/system/etc ]]
  rsync -av --delete /mnt/hexblade/system/etc/lukskeys/ /mnt/hexblade/crypt/
  chmod -R 0400 /mnt/hexblade/crypt
}

function cmd_key_save() {
  [[ -d /mnt/hexblade/system/etc ]]
  rsync -av --delete /mnt/hexblade/crypt/ /mnt/hexblade/system/etc/lukskeys/
}

function cmd_dump() {
  local hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
  cryptsetup luksDump "$hexblade_crypt_dev"
}

function cmd_close() {
  local hexblade_crypt_name="${1?'hexblade_crypt_name'}"
  cryptsetup close "$hexblade_crypt_name"
}


function cmd_open() {
  local hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
  local hexblade_crypt_name="${2?'hexblade_crypt_name is required'}"
  local hexblade_crypt_key="${3}"
  if ls "/dev/mapper/$hexblade_crypt_name"; then false; fi
  if [[ "x$hexblade_crypt_key" != "x" ]] && [[ -f "/mnt/hexblade/crypt/$hexblade_crypt_key.key" ]]; then
    cryptsetup open --key-file "/mnt/hexblade/crypt/$hexblade_crypt_key.key" "$hexblade_crypt_dev" "$hexblade_crypt_name"
  else
    cryptsetup open "$hexblade_crypt_dev" "$hexblade_crypt_name"
  fi
}

function cmd_format() {
  local hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
  local hexblade_crypt_key="${2?'keyname, like: master'}"
  [[ -f "/mnt/hexblade/crypt/$hexblade_crypt_key.key" ]]
  cryptsetup -v -q -y --type luks1 --cipher aes-xts-plain64 --hash sha256 luksFormat --key-file "/mnt/hexblade/crypt/$hexblade_crypt_key.key" --key-slot 0 "$hexblade_crypt_dev"
}

function cmd_pass_add() {
  local hexblade_crypt_dev="${1?'hexblade_crypt_dev is required'}"
  local hexblade_crypt_key="${2?'keyname, like: master'}"
  local hexblade_crypt_slot="${3?'slot, from 0 to 7'}"
  cryptsetup luksAddKey --key-file "/mnt/hexblade/crypt/$hexblade_crypt_key.key" --key-slot "$hexblade_crypt_slot" "$hexblade_crypt_dev"
}

function cmd_crypttab_start() {
  [[ -d /mnt/hexblade/system/etc ]]
  rm -rf /mnt/hexblade/system/etc/lukskeys || true
  mkdir /mnt/hexblade/system/etc/lukskeys
  chown -R root:root /mnt/hexblade/system/etc/lukskeys/
  chmod -Rv 0400 /mnt/hexblade/system/etc/lukskeys/
  echo 'GRUB_ENABLE_CRYPTODISK=y' | tee /mnt/hexblade/system/etc/default/grub.d/hexblade-crypt.cfg
  echo "KEYFILE_PATTERN=/etc/lukskeys/*.key" > /mnt/hexblade/system/etc/cryptsetup-initramfs/conf-hook 
  (grep -v '^UMASK=' /mnt/hexblade/system/etc/initramfs-tools/initramfs.conf && echo "UMASK=0077") > /tmp/__initramfs.conf
  cp /tmp/__initramfs.conf /mnt/hexblade/system/etc/initramfs-tools/initramfs.conf
  echo '# <target name>	<source device>		<key file>	<options>' > /mnt/hexblade/system/etc/crypttab
}

function cmd_crypttab_add() {
  local hexblade_crypt_name="${1?'hexblade_crypt_name'}"
  local hexblade_crypt_key="${2?'keyname, like: master, use none to ask the password'}"
  local hexblade_crypt_kf="none"
  
  local hexblade_crypt_dev="$(lsblk -ls -o PATH "/dev/mapper/$hexblade_crypt_name" | head -n 3 | tail -n 1)"
  [[ "x$hexblade_crypt_dev" != "x" ]]
  local hexblade_crypt_id="$(blkid -o value -s UUID "$hexblade_crypt_dev")"
  [[ "x$hexblade_crypt_id" != "x" ]]
  
  if [[ "x$hexblade_crypt_key" != "xnone" ]]; then
    hexblade_crypt_kf="/etc/lukskeys/$hexblade_crypt_key.key"
    cp "/mnt/hexblade/crypt/$hexblade_crypt_key.key" "/mnt/hexblade/system$hexblade_crypt_kf"
    chmod -v 0400 "/mnt/hexblade/system$hexblade_crypt_kf"
  fi
  echo -e "$hexblade_crypt_name\tUUID=$hexblade_crypt_id\t$hexblade_crypt_kf\tluks" | tee -a /mnt/hexblade/system/etc/crypttab
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"