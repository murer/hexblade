#!/bin/sh

set -e

PREREQ=""

prereqs () {
	echo "${PREREQ}"
}

case "${1}" in
	prereqs)
		prereqs
		exit 0
		;;
esac

. /usr/share/initramfs-tools/hook-functions

set -x

for k in $(ls /etc/luksparts/*.key || true); do
    copy_file binary "$k"
done

exit 0
