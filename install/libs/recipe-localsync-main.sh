

function recipe_localsync_from_backup() {
    read -p 'Stick partition (it will be formatted): ' hexblade_recipe_dev
    read -p 'Stick grub install device: ' hexblade_recipe_grub_dev
    read -p 'Internal device (it will be formatted): ' hexblade_recipe_local_dev
    read -p 'Internal swap size (sample: 16GB): ' hexblade_recipe_swap_size
    read -p 'Internal root partiition size (sample: 64GB): ' hexblade_recipe_local_root_size

    cmd_crypt_format "$hexblade_recipe_dev"
}