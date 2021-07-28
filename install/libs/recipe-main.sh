
cmd_recipe_basic() {
  hexblade_dev="${1?'target is required'}"
  mkfs.ext4 -L ROOT "$hexblade_dev"
  
  cmd_struct
}
