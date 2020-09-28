#!/bin/bash -xe

hexblade_dev_package="${1?'standard or basic'}"

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

hexblade_user="$(cat target/config/user/user.txt)"

rm -rf "/mnt/hexblade/installer/home/$hexblade_user/hexblade"
cp -R "." "/mnt/hexblade/installer/home/$hexblade_user/hexblade"
USER="$hexblade_user" HOME="/home/$hexblade_user" arch-chroot /mnt/hexblade/installer chown -R "$hexblade_user:$hexblade_user" "/home/$hexblade_user"

echo "$hexblade_user ALL=(ALL) NOPASSWD: ALL" > /mnt/hexblade/installer/etc/sudoers.d/tmp

USER="$hexblade_user" HOME="/home/$hexblade_user" arch-chroot -u "$hexblade_user:$hexblade_user" /mnt/hexblade/installer "/home/$hexblade_user/hexblade/packages/install-$hexblade_dev_package.sh"

rm /mnt/hexblade/installer/etc/sudoers.d/tmp
