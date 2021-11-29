#!/bin/bash -xe

[[ "$UID" == "0" ]]

hexes_original_dir="${1?'original dir, sample: /var/lib/docker'}"
hexes_dest_dir="${2?'dest dir, sample: /localdata/root/var/lib/docker'}"

[[ -d "$hexes_original_dir" ]]
if ls "$hexes_dest_dir"; then exit 1; fi

mkdir -p "$hexes_dest_dir"
rmdir "$hexes_dest_dir"

mv "$hexes_original_dir" "$hexes_dest_dir"
ln -s "$hexes_dest_dir"  "$hexes_original_dir" 
