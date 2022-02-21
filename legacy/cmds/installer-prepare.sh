#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

cd "$(dirname "$0")/.."
pwd

./packages/tools/tools.sh install
