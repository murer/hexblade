#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

apt $HEXBLADE_APT_ARGS -y install --no-install-recommends lxdm

if [ ! -f /etc/lxdm.original.tar.gz ]; then
	cd /etc
	tar czf lxdm.original.tar.gz lxdm/*
	cd -
fi

cp -Rv etc/* /etc/lxdm
cp -Rv Hexblade /usr/share/lxdm/themes
