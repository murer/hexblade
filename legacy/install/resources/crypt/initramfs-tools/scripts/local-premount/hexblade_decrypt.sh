#!/bin/sh 

set -e

PREREQ="btrfs"

# Output pre-requisites
prereqs()
{
        echo "$PREREQ"
}

case "$1" in
    prereqs)
        prereqs
        exit 0
        ;;
esac

set -x

mkdir /secrets
mount -t btrfs -r -o subvol=@secrets /dev/mapper/MAINCRYPTED /secrets

ls /secrets/parts/id-*.id | while read k; do
        crypt_part_name="$(echo "$k" | sed 's/.*\/id-\(.*\)\.id/\1/g')"
        cryptsetup open --key-file "/secrets/parts/key-$crypt_part_name.key" "/dev/disk/by-uuid/$(cat "$k")" "$crypt_part_name"
done
umount /secrets
rmdir /secrets


if grep "localsync" /proc/cmdline; then
	mkdir /syncsrc /syncdst
	localsync_root_id="$(echo "$ROOT" | sed 's/^UUID=//g')"
	mount -w "/dev/disk/by-uuid/$localsync_root_id" /syncdst
	mount -t btrfs -r -o subvol=@root /dev/mapper/MAINCRYPTED /syncsrc
	rsync -a --delete /syncsrc/ /syncdst/
	mv /syncdst/etc/fstab.localsync /syncdst/etc/fstab
	grep -v ^MAINCRYPTED /syncdst/etc/crypttab > /syncdst/etc/crypttab.tmp || true
	mv /syncdst/etc/crypttab.tmp /syncdst/etc/crypttab || true

	# sh

	umount /syncdst
	umount /syncsrc
	cryptsetup close MAINCRYPTED
	rmdir /syncsrc /syncdst

	sh

fi


