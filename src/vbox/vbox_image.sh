#!/bin/bash -xe

function cmd_abc() {
    VBoxManage guestcontrol hex_vbox_base --username ubuntu --password ubuntu run -- /usr/bin/mkdir -p /tmp/hexvbox
    VBoxManage guestcontrol hex_vbox_base --username ubuntu --password ubuntu copyto --follow -R --target-directory /tmp/hexvbox ..
    VBoxManage guestcontrol hex_vbox_base --username ubuntu --password ubuntu run -E HEX_TARGET_USER=hex -E HEX_TARGET_PASS=hex -- /tmp/hexvbox/src/recipe/util/min_mbr.sh
}

function cmd_create_base() {
    ./vbox.sh vm_create_from_iso /mnt/hexblade/iso/hexblade.iso hex_vbox_base 5050
    ./vbox.sh vm_start hex_vbox_base
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"