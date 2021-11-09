

function cmd_recipe_localdata_from_backup() {

    [[ -d /mnt/hexblade/backup ]]

    read -p 'Crypt partition (it will be formatted): ' hexblade_recipe_dev
    read -p 'EFI Partition (blank): ' hexblade_recipe_efi_part
    read -p 'Grub install device: ' hexblade_recipe_grub_dev
    #read -p 'Internal device (it will be formatted): ' hexblade_recipe_local_dev
    read -p 'Swap size (sample: 16GB): ' hexblade_recipe_swap_size
    read -p 'Root partiition size (sample: 64GB): ' hexblade_recipe_local_root_size

    cmd_crypt_format "$hexblade_recipe_dev" LOCALCRYPTED

    cmd_lvm_format /dev/mapper/LOCALCRYPTED LOCAL
    cmd_lvm_add LOCAL SWAP "$hexblade_recipe_swap_size"
    cmd_lvm_add LOCAL ROOT "$hexblade_recipe_local_root_size"
    cmd_lvm_add LOCAL DATA '100%FREE'

    mkswap -L SWAP /dev/mapper/LOCAL-SWAP
    mkfs.ext4 -L ROOT /dev/mapper/LOCAL-ROOT
    mkfs.ext4 -L DATA /dev/mapper/LOCAL-DATA
    swapon /dev/mapper/LOCAL-SWAP
    
    mkdir -p /mnt/hexblade/installer
    mount /dev/mapper/LOCAL-ROOT /mnt/hexblade/installer

    cmd_backup_restore

    if [[ "x$hexblade_recipe_efi_part" ]]; then
        cmd_efi_mount_if_needed "$hexblade_recipe_efi_part"
    fi
 
    mkdir -p /mnt/hexblade/installer/localdata
    mount /dev/mapper/LOCAL-DATA /mnt/hexblade/installer/localdata

    cmd_crypt_tab LOCALCRYPTED
    cmd_struct_fstab
    #cmd_crypt_initramfs
    cmd_crypt_localsync /dev/mapper/LOCAL-ROOT

    cmd_boot "$hexblade_recipe_grub_dev"
}
