#!/bin/bash -xe

base_path="/home/murer/files/bak/lavaburst"

function cmd_open() {
	ls /dev/mapper/MASTERCRYPTED || cryptsetup open --key-file "$base_path/lukskeys/master.key" /dev/nvme0n1p4 MASTERCRYPTED
}

function cmd_close() {
	../../src/lib/util/crypt.sh close MASTERCRYPTED
}

function cmd_master_backup() {
	mkdir -p "$base_path/entry/master"
	[ -d "$base_path/entry/master/etc" ] || mount /dev/mapper/MASTERCRYPTED "$base_path/entry/master"
	mkdir -p "$base_path/copy/master"
	rsync -acv --delete "$base_path/entry/master/" "$base_path/copy/master/"
	umount "$base_path/entry/master"
}

function cmd_master_restore() {
	mkdir -p "$base_path/entry/master"
	[ -d "$base_path/entry/master/etc" ] || mount /dev/mapper/MASTERCRYPTED "$base_path/entry/master"
	rsync -acv --delete "$base_path/copy/master/" "$base_path/entry/master/"
	umount "$base_path/entry/master"
}


function cmd_efi_backup() {
	mkdir -p "$base_path/entry/efi"
	[ -d "$base_path/entry/efi/EFI" ] || mount /dev/nvme0n1p1 "$base_path/entry/efi"
	mkdir -p "$base_path/copy/efi"
	rsync -acv --delete "$base_path/entry/efi/" "$base_path/copy/efi/"
	umount "$base_path/entry/efi"
}

function cmd_efi_restore() {
	mkdir -p "$base_path/entry/efi"
	[ -d "$base_path/entry/efi/etc" ] || mount /dev/nvme0n1p1 "$base_path/entry/efi"
	rsync -acv --delete "$base_path/copy/efi/" "$base_path/entry/efi/"
	umount "$base_path/entry/efi"
}




cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
