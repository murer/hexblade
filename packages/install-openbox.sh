#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

sudo apt-get -y install openbox nitrogen tint2 xscreensaver gmrun arandr pcmanfm libnotify-bin

if [ ! -f /etc/X11/openbox.original.tar.gz ]; then
	cd /etc/X11
	sudo tar czf openbox.original.tar.gz openbox/*
	sudo rm -rfv openbox/*
	cd -
fi

sudo cp -Rv openbox/etc/X11/openbox/* /etc/X11/openbox

cp -v openbox/home/xinitrc ~/.xinitrc
cp -v openbox/home/xinitrc ~/.xsessionrc
