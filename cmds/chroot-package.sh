#!/bin/bash -xe

hex_dev_package="${1?'standard or basic'}"

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

hex_user="$(cat target/config/user/user.txt)"

rm -rf "/mnt/installer/home/$hex_user/hex"
cp -R "." "/mnt/installer/home/$hex_user/hex"
USER="$hex_user" HOME="/home/$hex_user" arch-chroot /mnt/installer chown -R "$hex_user:$hex_user" "/home/$hex_user"

echo "$hex_user ALL=(ALL) NOPASSWD: ALL" > /mnt/installer/etc/sudoers.d/tmp

USER="$hex_user" HOME="/home/$hex_user" arch-chroot -u "$hex_user:$hex_user" /mnt/installer "/home/$hex_user/hex/packages/install-$hex_dev_package.sh"

rm /mnt/installer/etc/sudoers.d/tmp
