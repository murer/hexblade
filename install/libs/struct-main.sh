
cmd_struct() {
  sudo mkdir -p /mnt/hexblade/installer
}

cmd_struct_umount() {
  sudo umount -R /mnt/hexblade/installer
}

cmd_fstab() {
  genfstab -U /mnt/hexblade/installer | tee /mnt/hexblade/installer/etc/fstab
}