#!/bin/bash -xe

function cmd_test() {
  ../../../src/pack/util/graphics.sh xterm
  ../../../src/pack/util/graphics.sh mousepad
  ../../../src/pack/util/graphics.sh xfce4
  ../../../src/pack/util/graphics.sh pcmanfm
  ../../../src/pack/util/graphics.sh firefox
  ../../../src/pack/util/graphics.sh network
  ../../../src/pack/util/graphics.sh thunar
  ../../../src/pack/util/graphics.sh ubiquity
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
