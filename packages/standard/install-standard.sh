#!/bin/bash -xe

cd "$(dirname "$0")/.."
pwd

./tools/install-tools.sh
./graphics/install-graphics.sh
./lxterminal/install-lxterminal.sh
./firefox/install-firefox.sh
./sound/install-sound.sh
./networkmanager/install-networkmanager.sh
./openbox/install-openbox.sh
./lxdm/install-lxdm.sh
