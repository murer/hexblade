#!/bin/bash -xe

cd "$(dirname "$0")/.."
pwd

./graphics/install-graphics.sh
./graphics/install-firefox.sh
./sound/install-sound.sh
./openbox/install-openbox.sh
./lxdm/install-lxdm.sh
