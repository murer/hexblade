
cmd_recipe_basic() {
  hexblade_dev="${1?'target is required'}"
  read -p 'Format (s/n): ' hexblade_recipe_format
  if [[ "x$hexblade_recipe_format" == "xy" ]]; then
    mkfs.ext4 -L ROOT "$hexblade_dev"
  fi
  
  cmd_struct

  [[ -d /mnt/hexblade/installer/bin ]] || cmd_basesys_strap
  cmd_basesys_install
  cmd_basesys_kernel
}
