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

priv_ask() {
  tmp_prompt="${1?'prompt'}" && shift
  tmp_file="${1?'file'}" && shift
  read "$@" -p "$tmp_prompt" tmp_value
  echo "$tmp_file=\"$tmp_value\"" >> "target/config/params.txt"
}

cmd_ask() {
  rm target/config/params.txt || true
  set +x
  priv_ask 'Change apt mirror (us): ' hexblade_apt_mirror
  priv_ask 'Generate fstab (y/n): ' hexblade_dev_fstab
  priv_ask 'Crypt Partition (blank): ' hexblade_dev_lvm
  priv_ask 'Grub Install Device (blank): ' hexblade_grub_dev
  priv_ask 'Hostname: ' hexblade_hostname
  priv_ask 'User: ' hexblade_user
  priv_ask 'Pass: ' hexblade_pass -s
  echo ""
  priv_ask 'Pass (Again): ' hexblade_pass_again -s
  echo ""

  source target/config/params.txt
  if [[ "x$hexblade_pass" != "x$hexblade_pass_again" ]]; then
    echo "wrong pass"
    false
  fi

  set -x
}

cmd_all() {
  cmd_init
  cmd_ask

  source target/config/params.txt

  cmd_apt_mirror
  cmd_fstab
  cmd_grub
  cmd_hostname
  cmd_user
}

cd "$(dirname "$0")/.."; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
