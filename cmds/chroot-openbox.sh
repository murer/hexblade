#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

hex_user="$(cat target/config/user/user.txt)"

rm -rf "/mnt/installer/home/$hex_user/hex"
cp -R "." "/mnt/installer/home/$hex_user/hex"
arch-chroot /mnt/installer chown -R "$hex_user:$hex_user" "/home/$hex_user"

arch-chroot \
  -u "$hex_user:$hex_user" \
  /mnt/installer \
  "/home/$hex_user/hex/packages/install-graphics-util.sh"
