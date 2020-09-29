#!/bin/bash -xe

hexblade_dev_package="${1?'standard or basic'}"

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

set +x
source target/config/params.txt || true
set -x

rsync -vah packages/ "/mnt/hexblade/installer/home/$hexblade_user/hexblade/packages/"

USER="$hexblade_user" HOME="/home/$hexblade_user" arch-chroot /mnt/hexblade/installer chown -R "$hexblade_user:$hexblade_user" "/home/$hexblade_user"
USER="$hexblade_user" HOME="/home/$hexblade_user" arch-chroot /mnt/hexblade/installer "/home/$hexblade_user/hexblade/packages/$hexblade_dev_package/install-$hexblade_dev_package.sh"

#echo "$hexblade_user ALL=(ALL) NOPASSWD: ALL" > /mnt/hexblade/installer/etc/sudoers.d/tmp
#arch-chroot /mnt/hexblade/installer sudo -u "$hexblade_user" "/home/$hexblade_user/hexblade/packages/install-$hexblade_dev_package.sh"
#rm /mnt/hexblade/installer/etc/sudoers.d/tmp
