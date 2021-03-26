#!/bin/bash -xe

cd "$(dirname "$0")/.."
pwd

./tools/tools.sh install

./graphics/graphics.sh xterm
./graphics/graphics.sh mousepad
./graphics/graphics.sh xfce4-screenshooter
./graphics/graphics.sh pcmanfm

./lxterminal/install-lxterminal.sh
./firefox/install-firefox.sh
./pulseaudio/install-pulseaudio.sh
./networkmanager/install-networkmanager.sh
./openbox/install-openbox.sh
./lxdm/install-lxdm.sh
