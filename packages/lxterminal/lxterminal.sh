#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

apt -y install ttf-ubuntu-font-family lxterminal

if [[ ! -f /usr/share/lxterminal/lxterminal.conf.bak ]]; then
  cp /usr/share/lxterminal/lxterminal.conf /usr/share/lxterminal/lxterminal.conf.bak
fi
cp config/lxterminal.conf /usr/share/lxterminal/lxterminal.conf
