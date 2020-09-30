#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

apt $HEXBLADE_APT_ARGS -y install xorg i3 xautolock arandr xinit

if [ ! -f /etc/i3.original.tar.gz ]; then
	cd /etc
	tar czf i3.original.tar.gz i3
	rm -rfv i3
	cd -
fi

cp -TRv etc/i3 /etc/i3

#cp -v home/xinitrc ~/.xinitrc
