#!/bin/bash -xe

[[ "x$UID" != "x0" ]]

cmd_init() {
  rm -rf target || true
  mkdir target
  cp -R config target
  genfstab -U /mnt/installer | sudo tee /mnt/installer/etc/fstab
  hex_lvm_id="$(sudo blkid -o value -s UUID "$HEX_DEV_LVM")"
  echo -e "CRYPTED\tUUID=$hex_lvm_id\tnone\tluks,initramfs" > target/config/etc.pre/crypttab
}

cmd_hostname() {
  hex_hostname="${hex_hostname?'hostname'}"
  echo "$hex_hostname" > target/config/etc.pre/hostname
  echo "
  127.0.0.1 localhost
  ::1 localhost ip6-localhost ip6-loopback
  ff02::1 ip6-allnodes
  ff02::2 ip6-allrouters
  127.0.0.1 $hex_hostname.localdomain $hex_hostname
  " > target/config/etc.pre/hosts
}

cmd_user() {
  set +x
  hex_user="${hex_user?'user'}"
  hex_pass="${hex_pass?'pass'}"
  echo "$hex_user" > target/config/user/user.txt
  openssl passwd -6 "$hex_pass" > target/config/user/pass.txt
  set -x
}

cmd_all() {
  read -p 'Hostname: ' hex_hostname
  read -p 'User: ' hex_user
  read -sp 'Pass: ' hex_pass

  cmd_init
  cmd_hostname
  cmd_user
}

cd "$(dirname "$0")/.."; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
