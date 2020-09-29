#!/bin/bash -xe

cd "$(dirname "$0")/.."
pwd

./graphics/install-graphics.sh
./sound/install-sound.sh
./openbox/install-openbox.sh
./lxdm/install-lxdm.sh
