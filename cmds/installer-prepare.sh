#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

./packages/prepareinstaller/install-prepareinstaller.sh
