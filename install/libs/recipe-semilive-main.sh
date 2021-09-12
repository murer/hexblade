
cmd_recipe_semilive_efi() {
  cd /mnt/hexblade/image
  grub-mkstandalone \
   --format=x86_64-efi \
   --output=EFI/bootx64.efi \
   --locales="" \
   --fonts="part_gpt cryptodisk luks lvm ext2" \
   "boot/grub/grub.cfg=isolinux/grub.cfg"
  cd -
}

cmd_recipe_semilive() {
  cmd_recipe_live_config
  cmd_recipe_live_system
  #cmd_recipe_live_standard
  #cmd_recipe_live_iso

  cmd_live_compress
  cmd_recipe_semilive_efi
}
