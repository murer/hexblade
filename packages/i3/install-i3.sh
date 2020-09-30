#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

sudo apt $HEXBLADE_APT_ARGS -y install xorg i3 xautolock arandr xinit

if [ ! -f /etc/i3.original.tar.gz ]; then
	cd /etc
	sudo tar czf i3.original.tar.gz i3
	sudo rm -rfv i3
	cd -
fi

sudo cp -TRv etc/i3 /etc/i3

#cp -v home/xinitrc ~/.xinitrc
