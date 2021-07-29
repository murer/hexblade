
cmd_struct() {
  sudo mkdir -p /mnt/hexblade/installer
}

cmd_struct_umount() {
  sudo umount -R /mnt/hexblade/installer || true
  sudo umount -R /mnt/hexblade/secrets || true
  sudo umount -R /mnt/hexblade/localsync || true
  sudo umount -R /mnt/hexblade/btrfs/* || true
  sudo umount -R /mnt/hexblade/backup || true
}

cmd_struct_fstab() {
  genfstab -U /mnt/hexblade/installer | tee /mnt/hexblade/installer/etc/fstab
}