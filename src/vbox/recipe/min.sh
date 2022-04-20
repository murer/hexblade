#!/bin/bash -xe

[[ "x$UID" != "x0" ]]

function cmd_from_iso() {
    ../util/vbox.sh vm_create_from_iso hexbuild
    ../util/vbox.sh vm_start hexbuild
    ../util/vbox.sh vm_poweroff hexbuild
    ../util/vbox.sh vm_delete hexbuild
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"