#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

[[ -f "target/config/grub.dev" ]]

if [[ -d /mnt/installer/boot/efi ]]; then
  arch-chroot /mnt/installer apt $hexblade_apt_args-y install grub-efi
fi

cp -R target/config/etc.post/* /mnt/installer/etc
sudo arch-chroot /mnt/installer update-grub
sudo arch-chroot /mnt/installer grub-install "$(cat target/config/grub.dev)"
sudo arch-chroot /mnt/installer update-initramfs -u -k all
