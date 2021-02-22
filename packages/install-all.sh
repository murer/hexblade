#!/bin/bash -xe

cd "$(dirname "$0")"
pwd

find -mindepth 1 -maxdepth 1 -type d ! -name '.*' | cut -d'/' -f2 | while read k; do
  "./$k/install-$k.sh"
done
