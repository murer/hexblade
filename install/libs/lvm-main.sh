
function cmd_lvm_format() {
    hexblade_lvm_dev="${1?'hexblade_lvm_dev'}"
    hexblade_lvm_name="${2?'hexblade_lvm_name'}"
    pvcreate "$hexblade_lvm_dev"
    vgcreate "$hexblade_lvm_name" "$hexblade_lvm_dev"
}

function cmd_lvm_add() {
    hexblade_lvm_name="${1?'hexblade_lvm_name'}"
    hexblade_lvm_subname="${2?'hexblade_lvm_subname'}"
    hexblade_lvm_size="${3?'hexblade_lvm_size'}"
    if echo "$hexblade_lvm_size" | grep 'FREE$'; then
        lvcreate -l "$hexblade_lvm_size" "$hexblade_lvm_name" -n "$hexblade_lvm_subname"
    else
        lvcreate -L "$hexblade_lvm_size" "$hexblade_lvm_name" -n "$hexblade_lvm_subname"
    fi
}