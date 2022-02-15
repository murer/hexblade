#!/bin/bash -xe

function cmd_rsync() {
  mkdir -p /mnt/hexblade/system/installer/hexblade
  rsync -av --delete --exclude .git ../../ /mnt/hexblade/system/installer/hexblade/
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"

