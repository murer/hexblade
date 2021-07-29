
function cmd_btrfs_format() {
    hexblade_btrfs_dev="${1?'hexblade_btrfs_dev is required'}"
    hexblade_btrfs_name="${2?'hexblade_btrfs_name is required'}"
    dd if=/dev/zero "of=$hexblade_btrfs_dev" bs=1M count=32
    mkfs.btrfs -L "$hexblade_btrfs_name" "$hexblade_btrfs_dev"
    cmd_btrfs_mount "$hexblade_btrfs_dev"
}

function cmd_btrfs_mount() {
    hexblade_btrfs_dev="${1?'hexblade_btrfs_dev is required'}"
    hexblade_btrfs_id="$(blkid -o value -s UUID "$hexblade_btrfs_dev")"
    mkdir -p "/mnt/hexblade/btrfs/$hexblade_btrfs_id"
    mount -t btrfs -o compress=lzo "$hexblade_btrfs_dev" "/mnt/hexblade/btrfs/$hexblade_btrfs_id"
}

function cmd_btrfs_subvol_create() {
    hexblade_btrfs_dev="${1?'hexblade_btrfs_dev is required'}"
    hexblade_btrfs_subvol_name="${2?'hexblade_btrfs_subvol_name is required'}"

    hexblade_btrfs_id="$(blkid -o value -s UUID "$hexblade_btrfs_dev")"
    btrfs subvolume create "/mnt/hexblade/btrfs/$hexblade_btrfs_id/@$hexblade_btrfs_subvol_name"
}

function cmd_btrfs_subvol_mount() {
    hexblade_btrfs_dev="${1?'hexblade_btrfs_dev is required'}"
    hexblade_btrfs_subvol_name="${2?'hexblade_btrfs_subvol_name is required'}"
    hexblade_btrfs_point="${3?'hexblade_btrfs_point is required'}"

    mkdir -p "$hexblade_btrfs_point"
    mount -t btrfs -o "compress=lzo,subvol=@$hexblade_btrfs_subvol_name" "$hexblade_btrfs_dev" "$hexblade_btrfs_point"
}