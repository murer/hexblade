#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

sudo apt $HEXBLADE_APT_ARGS -y install --no-install-recommends lxdm

if [ ! -f /etc/lxdm.original.tar.gz ]; then
	cd /etc
	sudo tar czf lxdm.original.tar.gz lxdm/*
	cd -
fi

sudo cp -Rv etc/* /etc/lxdm
sudo cp -Rv Hexblade /usr/share/lxdm/themes
