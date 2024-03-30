#!/bin/bash -xe


function cmd_zero() {
  pwd
  echo "$0"
  ls
  vboxmanage controlvm hex_zero poweroff || true
  vboxmanage unregistervm hex_zero --delete || true
  vboxmanage closemedium hex_zero/hex_zero.vdi --delete || true
  rm hex_zero/hex_zero.vdi || true
  rmdir hex_zero || true
  [ ! -d hex_zero ]
  mkdir hex_zero
  vboxmanage clonemedium hex_one.vdi hex_zero/hex_zero.vdi
  vboxmanage modifymedium --compact hex_zero/hex_zero.vdi
  vboxmanage createvm --name hex_zero --ostype Ubuntu_64 --default --register
  #vboxmanage modifyvm hex_zero --cpus 2
  #vboxmanage storagectl hex_zero --name "SATA" --add sata --controller IntelAhci
  vboxmanage storageattach hex_zero --storagectl "SATA" --port 0 --device 0 --type hdd --medium hex_zero/hex_zero.vdi
  vboxmanage startvm hex_zero
  while ! vboxmanage guestcontrol hex_zero run --exe "/bin/bash" --username hex --password hex --putenv DEBIAN_FRONTEND=noninteractive --wait-stdout -- -c 'whoami'; do
    sleep 1;
  done
  vboxmanage guestcontrol hex_zero run --exe "/bin/bash" --username hex --password hex --putenv DEBIAN_FRONTEND=noninteractive --wait-stdout -- -c 'exec sudo apt update'
  vboxmanage guestcontrol hex_zero run --exe "/bin/bash" --username hex --password hex --putenv DEBIAN_FRONTEND=noninteractive --wait-stdout -- -c 'exec sudo apt -y upgrade'
  vboxmanage guestcontrol hex_zero run --exe "/bin/bash" --username hex --password hex --putenv DEBIAN_FRONTEND=noninteractive --wait-stdout -- -c 'exec sudo apt -y autoremove'


}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
