#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

[[ -f "target/config/grub.dev" ]]

if [[ -d /mnt/hexblade/installer/boot/efi ]]; then
  arch-chroot /mnt/hexblade/installer apt $HEXBLADE_APT_ARGS -y install grub-efi
fi

cp -R target/config/etc.post/* /mnt/hexblade/installer/etc

sudo arch-chroot /mnt/hexblade/installer update-grub
sudo arch-chroot /mnt/hexblade/installer grub-install "$(cat target/config/grub.dev)"
sudo arch-chroot /mnt/hexblade/installer update-initramfs -u -k all
