#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

if [[ -d /mnt/installer/boot/efi ]]; then
  arch-chroot /mnt/installer apt -y install grub-efi
fi

cp -R target/config/etc.post/* /mnt/installer/etc
sudo arch-chroot /mnt/installer update-grub
sudo arch-chroot /mnt/installer grub-install "$(cat target/config/grub.dev)"
sudo arch-chroot /mnt/installer update-initramfs -u -k all
