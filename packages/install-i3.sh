#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

sudo apt-get -y install xorg i3 xautolock arandr

if [ ! -f /etc/i3.original.tar.gz ]; then
	cd /etc
	sudo tar czf i3.original.tar.gz i3
	sudo rm -rfv i3
	cd -
fi

sudo cp -TRv i3/etc/i3 /etc/i3

cp -v i3/home/xinitrc ~/.xinitrc
cp -v i3/home/xinitrc ~/.xsessionrc
