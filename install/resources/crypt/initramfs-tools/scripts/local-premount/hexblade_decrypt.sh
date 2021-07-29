#!/bin/sh 

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

set +x
sh