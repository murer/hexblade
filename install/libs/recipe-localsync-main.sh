

function cmd_recipe_localsync_from_backup() {
    read -p 'Stick partition (it will be formatted): ' hexblade_recipe_dev
    read -p 'Stick grub install device: ' hexblade_recipe_grub_dev
    read -p 'Internal device (it will be formatted): ' hexblade_recipe_local_dev
    read -p 'Internal swap size (sample: 16GB): ' hexblade_recipe_swap_size
    read -p 'Internal root partiition size (sample: 64GB): ' hexblade_recipe_local_root_size

    cmd_crypt_format "$hexblade_recipe_dev"

    cmd_btrfs_format /dev/mapper/MAINCRYPTED MAIN
    cmd_btrfs_subvol_create /dev/mapper/MAINCRYPTED "snapshots"
    cmd_btrfs_subvol_create /dev/mapper/MAINCRYPTED "secrets"
    cmd_btrfs_subvol_create /dev/mapper/MAINCRYPTED "root"

    cmd_btrfs_subvol_mount /dev/mapper/MAINCRYPTED secrets /mnt/hexblade/secrets
    cmd_btrfs_subvol_mount /dev/mapper/MAINCRYPTED root /mnt/hexblade/installer

    if [[ "x$hexblade_recipe_grub_dev" ]]; then
        cmd_efi_mount_if_needed "$hexblade_recipe_grub_dev"
    fi

    cmd_crypt_format_with_file "$hexblade_recipe_local_dev" LOCALCRYPTED
    cmd_lvm_format /dev/mapper/LOCALCRYPTED LOCAL
    cmd_lvm_add LOCAL SWAP "$hexblade_recipe_swap_size"
    cmd_lvm_add LOCAL ROOT "$hexblade_recipe_local_root_size"
    cmd_lvm_add LOCAL DATA '100%FREE'

    mkswap -L SWAP /dev/mapper/LOCAL-SWAP
    mkfs.ext4 -L ROOT /dev/mapper/LOCAL-ROOT
    mkfs.ext4 -L DATA /dev/mapper/LOCAL-DATA
    swapon /dev/mapper/LOCAL-SWAP
    
    rsync -a --delete /mnt/hexblade/backup/ /mnt/hexblade/installer/
 
    mkdir -p /mnt/hexblade/installer/localdata
    mount /dev/mapper/LOCAL-DATA /mnt/hexblade/installer/localdata

    cmd_crypt_tab
    cmd_struct_fstab
    cmd_crypt_initramfs
    cmd_crypt_localsync /dev/mapper/LOCAL-ROOT

    cmd_boot "$hexblade_recipe_grub_dev"
}