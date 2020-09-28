#!/bin/bash -xe

[[ "x$UID" != "x0" ]]

cmd_init() {
  rm -rf target/config || true
  mkdir -p target
  cp -R config target
}

cmd_fstab() {
  if [[ "x$hexblade_dev_fstab" == "xy" ]]; then
    genfstab -U /mnt/hexblade/installer | sudo tee target/config/etc.pre/fstab
  fi
  if [[ "x$hexblade_dev_lvm" != "x" ]]; then
    hexblade_lvm_id="$(sudo blkid -o value -s UUID "$hexblade_dev_lvm")"
    echo -e "CRYPTED\tUUID=$hexblade_lvm_id\tnone\tluks,initramfs" > target/config/etc.pre/crypttab
    cp -R target/config/etc.crypt/* target/config/etc.post
  fi
  rm -rf target/config/etc.crypt
}

cmd_hostname() {
  hexblade_hostname="${hexblade_hostname?'hostname'}"
  echo "$hexblade_hostname" > target/config/etc.pre/hostname
  echo "
  127.0.0.1 localhost
  ::1 localhost ip6-localhost ip6-loopback
  ff02::1 ip6-allnodes
  ff02::2 ip6-allrouters
  127.0.0.1 $hexblade_hostname.localdomain $hexblade_hostname
  " > target/config/etc.pre/hosts
}

cmd_grub() {
  if [[ "x$hexblade_grub_dev" != "x" ]]; then
    echo "$hexblade_grub_dev" > target/config/grub.dev
  fi
}

cmd_user() {
  set +x
  hexblade_user="${hexblade_user?'user'}"
  hexblade_pass="${hexblade_pass?'pass'}"
  echo "$hexblade_user" > target/config/user/user.txt
  openssl passwd -6 "$hexblade_pass" > target/config/user/pass.txt
  set -x
}

cmd_apt_mirror() {
  if [[ "x$hexblade_apt_mirror" != "x" ]]; then
    sed -i.original "s/us\./$hexblade_apt_mirror./g" target/config/etc.pre/apt/sources.list
    echo "$hexblade_apt_mirror" > target/config/aptmirror.txt
  fi
}

cmd_all() {
  read -p 'Change apt mirror (us): ' hexblade_apt_mirror
  read -p 'Generate fstab (y/n): ' hexblade_dev_fstab
  read -p 'Crypt Partition (blank): ' hexblade_dev_lvm
  read -p 'Grub Install Device (blank): ' hexblade_grub_dev
  read -p 'Hostname: ' hexblade_hostname
  read -p 'User: ' hexblade_user
  read -sp 'Pass: ' hexblade_pass
  read -sp 'Pass (Again): ' hexblade_pass_again

  if [[ "x$hexblade_pass" != "x$hexblade_pass_again" ]]; then
    echo "wrong pass"
    false
  fi

  cmd_init
  cmd_apt_mirror
  cmd_fstab
  cmd_grub
  cmd_hostname
  cmd_user
}

cd "$(dirname "$0")/.."; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
