#!/bin/bash -xe

function cmd_from_iso() {
    local hexblade_iso="${1?'iso file'}"
    ../../lib/iso/iso.sh deiso "$hexblade_iso"
    # ../../lib/iso/iso.sh decompress
    # ../../lib/util/installer.sh chr passwd ubuntu
    ../../lib/iso/iso.sh iso
    ../../lib/iso/iso.sh sha256
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"