#!/bin/bash -xe

function cmd_open() {
	ls /dev/mapper/MASTERCRYPTED || cryptsetup open --key-file gen/lukskeys/master.key /dev/nvme0n1p4 MASTERCRYPTED
        mkdir -p /mnt/hexblade/system
	[ -d /mnt/hexblade/system/etc ] || mount /dev/mapper/MASTERCRYPTED /mnt/hexblade/system
}

function cmd_close() {
	umount /mnt/hexblade/system
	../../src/lib/util/crypt.sh close MASTERCRYPTED
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
