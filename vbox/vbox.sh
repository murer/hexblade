#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"

cmd_clean() {
  vboxmanage controlvm hexblade_build poweroff || true
  sleep 3
  vboxmanage unregistervm hexblade_build --delete || true
}

cmd_vm_create() {
  vboxmanage createvm --name hexblade_build --ostype Ubuntu_64 --register --default
  vboxmanage modifyvm hexblade_build \
    --memory 2048 \
    --cpus 2
  vboxmanage storageattach hexblade_build \
    --storagectl "IDE" \
    --port 0 \
    --device 1 \
    --type dvddrive \
    --medium "$(pwd)/../target/iso/hexblade.iso"
}

cmd_vm_start() {
  vboxmanage startvm hexblade_build --type gui
    while ! vboxmanage guestcontrol hexblade_build run --username ubuntu --password hexblade -- /usr/bin/whoami; do
    sleep 5
  done
}


cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
