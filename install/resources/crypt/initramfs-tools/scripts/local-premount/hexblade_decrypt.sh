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


if grep "localsync" /proc/cmdline; then
	# mount -t btrfs -r -o subvol=@root /dev/mapper/MAINCRYPTED /syncsrc
	# mount /dev/mapper/LOCAL-ROOT /syncdst
	# rsync -a --delete /syncsrc/ /syncdst/
	# hexblade_maincrypted_id="$(blkid -o value -s UUID /dev/mapper/MAINCRYPTED)"
	# [[ "x$hexblade_maincrypted_id" != "x" ]]
	# sed -e "s/UUID=$hexblade_maincrypted_id/$ROOT/g" /syncsrc/etc/fstab > /syncdst/etc/fstab 
	# grep -v ^MAINCRYPTED /syncdst/etc/crypttab > /syncdst/etc/crypttab.tmp || true
	# mv /syncdst/etc/crypttab.tmp /syncdst/etc/crypttab
	# if grep "localsyncdebug" /proc/cmdline; then
	# 	sh
	# fi
	# umount /syncdst
	# umount /syncsrc
	# cryptsetup close MAINCRYPTED
        sh
fi


