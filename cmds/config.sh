#!/bin/bash -xe

[[ "x$UID" != "x0" ]]

cmd_init() {
  rm -rf target/config || true
  mkdir -p target
  cp -R config target
}

cmd_fstab() {
  genfstab -U /mnt/installer | sudo tee target/config/etc.pre/fstab
  if [[ "x$hex_dev_lvm" != "x" ]]; then
    hex_lvm_id="$(sudo blkid -o value -s UUID "$hex_dev_lvm")"
    echo -e "CRYPTED\tUUID=$hex_lvm_id\tnone\tluks,initramfs" > target/config/etc.pre/crypttab
  fi
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

cmd_grub() {
  hex_grub_dev="${hex_grub_dev?'hex_grub_dev'}"
  echo "$hex_grub_dev" > target/config/grub.dev
}

cmd_user() {
  set +x
  hex_user="${hex_user?'user'}"
  hex_pass="${hex_pass?'pass'}"
  echo "$hex_user" > target/config/user/user.txt
  openssl passwd -6 "$hex_pass" > target/config/user/pass.txt
  set -x
}

cmd_install() {
  read -p 'Crypt Partition: ' hex_dev_lvm
  read -p 'Grub Install Device: ' hex_grub_dev
  read -p 'Hostname: ' hex_hostname
  read -p 'User: ' hex_user
  read -sp 'Pass: ' hex_pass
  read -sp 'Pass (Again): ' hex_pass_again

  if [[ "x$hex_pass" != "x$hex_pass_again" ]]; then
    echo "wrong pass"
    false
  fi

  cmd_init
  cmd_fstab
  cmd_grub
  cmd_hostname
  cmd_user
}

cmd_live() {
  read -p 'Hostname: ' hex_hostname
  read -p 'User: ' hex_user
  read -sp 'Pass: ' hex_pass
  read -sp 'Pass (Again): ' hex_pass_again

  if [[ "x$hex_pass" != "x$hex_pass_again" ]]; then
    echo "wrong pass"
    false
  fi

  cmd_init
  cmd_hostname
  cmd_user

}

cd "$(dirname "$0")/.."; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
