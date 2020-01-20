#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

./install-java-64.sh
./install-maven.sh
./install-atom.sh
./install-chrome.sh
./install-docker.sh
./install-graphics-util.sh
./install-sound.sh
./install-i3.sh
