#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

./install-basic.sh
./install-atom.sh
./install-chrome.sh
