#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

./basic/install-basic.sh
./atom/install-atom.sh
./chrome/install-chrome.sh
