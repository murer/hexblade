#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

./install-graphics-util.sh
./install-sound.sh
./install-openbox.sh
./install-lxdm.sh
