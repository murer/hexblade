#!/bin/bash -xe

function cmd_gen() {
  genfstab -U /mnt/hexblade/system | tee /mnt/hexblade/system/etc/fstab
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"

