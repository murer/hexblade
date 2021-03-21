#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

apt -y install openbox tint2 gmrun arandr xinit
apt -y install --no-install-recommends libnotify-bin xfce4-notifyd
apt -y install --no-install-suggests xscreensaver 
#apt -y install nitrogen

if [ ! -f /etc/xdg/tint2.original.tar.gz ]; then
	cd /etc/xdg
	tar czf tint2.original.tar.gz tint2/*
	rm -rfv tint2/*
	cd -
fi

cp -Rv tint2/* /etc/xdg/tint2

if [ ! -f /etc/xdg/openbox.original.tar.gz ]; then
	cd /etc/xdg
	tar czf openbox.original.tar.gz openbox/*
	rm -rfv openbox/*
	cd -
fi

cp -Rv etc/xdg/openbox/* /etc/xdg/openbox

#cp -v home/xinitrc ~/.xinitrc
