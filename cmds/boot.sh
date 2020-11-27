#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

set +x
source target/config/params.txt || true
set -x

[[ "x$hexblade_grub_dev" != "x" ]]

DEBIAN_FRONTEND=noninteractive arch-chroot /mnt/hexblade/installer apt -y install linux-firmware

if [[ -d /mnt/hexblade/installer/boot/efi ]]; then
  arch-chroot /mnt/hexblade/installer apt -y install grub-efi
fi

cp -R target/config/etc.post/* /mnt/hexblade/installer/etc

arch-chroot /mnt/hexblade/installer update-grub
arch-chroot /mnt/hexblade/installer grub-install "$hexblade_grub_dev"
arch-chroot /mnt/hexblade/installer update-initramfs -u -k all
