#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

sudo apt -y install openbox nitrogen tint2 xscreensaver gmrun arandr pcmanfm libnotify-bin xinit

if [ ! -f /etc/xdg/tint2.original.tar.gz ]; then
	cd /etc/xdg
	sudo tar czf tint2.original.tar.gz tint2/*
	sudo rm -rfv tint2/*
	cd -
fi

sudo cp -Rv tint2/* /etc/xdg/tint2

if [ ! -f /etc/xdg/openbox.original.tar.gz ]; then
	cd /etc/xdg
	sudo tar czf openbox.original.tar.gz openbox/*
	sudo rm -rfv openbox/*
	cd -
fi

sudo cp -Rv openbox/etc/xdg/openbox/* /etc/xdg/openbox

cp -v openbox/home/xinitrc ~/.xinitrc
cp -v openbox/home/xinitrc ~/.xsessionrc
