#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

sudo apt -y install lxdm

if [ ! -f /etc/lxdm.original.tar.gz ]; then
	cd /etc
	sudo tar czf lxdm.original.tar.gz lxdm/*
	cd -
fi

sudo cp -Rv lxdm/* /etc/lxdm