#!/bin/bash -xe

function cmd_vm() {
  vboxmanage unregistervm test --delete || true
  mkdir -p ./target/test
  vboxmanage createvm --name test --ostype Ubuntu_64 --basefolder "$(pwd)/target/test" --register
  vboxmanage modifyvm "$(pwd)/target/test/test/test.vbox" --ioapic on                     
  vboxmanage modifyvm test --memory 2048 --vram 128       
  vboxmanage modifyvm test --nic1 nat 
  vboxmanage storagectl test --name IDE --add ide
  vboxmanage storageattach test --storagectl IDE --port 0 --device 0 --type dvddrive --medium /mnt/hexblade/iso/hexblade.iso
  vboxmanage startvm test --type gui -E aaa=bbb
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"