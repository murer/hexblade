
function cmd_boot() {

    hexblade_grub_dev="${1?'hexblade_grub_dev is required'}"

    # if [[ -d /mnt/hexblade/installer/boot/efi ]]; then
    #     arch-chroot /mnt/hexblade/installer apt -y install grub-efi
    # else
    #     arch-chroot /mnt/hexblade/installer apt -y install grub-pc
    # fi

    echo 'GRUB_CMDLINE_LINUX_DEFAULT="verbose nosplash"' > /mnt/hexblade/installer/etc/default/grub.d/hexblade-linux-cmdline.cfg

    arch-chroot /mnt/hexblade/installer update-grub
    arch-chroot /mnt/hexblade/installer grub-install "$hexblade_grub_dev"
    arch-chroot /mnt/hexblade/installer update-initramfs -u -k all
}

