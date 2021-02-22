#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"

cmd_clean() {
  vboxmanage controlvm hexblade_build poweroff || true
  sleep 2
  vboxmanage unregistervm hexblade_build --delete || true
  sleep 1
  vboxmanage closemedium "$(pwd)/../target/vbox/hexblade_build/hexblade_build.vdi" --delete || true
  rm -rf "$(pwd)/../target/vbox" || true
  rm -rf "$(pwd)/../target/ova" || true
}

cmd_vm_create() {
  mkdir -p "$(pwd)/../target/vbox"
  vboxmanage createvm --name hexblade_build \
    --ostype Ubuntu_64 \
    --register \
    --default \
    --basefolder "$(pwd)/../target/vbox"
  vboxmanage modifyvm hexblade_build \
    --memory 2048 \
    --cpus 2
  vboxmanage storageattach hexblade_build \
    --storagectl "IDE" \
    --port 0 \
    --device 1 \
    --type dvddrive \
    --medium "$(pwd)/../target/iso/hexblade.iso"
  vboxmanage createmedium --filename "$(pwd)/../target/vbox/hexblade_build/hexblade_build.vdi" \
    --size 16384 \
    --format VDI \
    --variant Standard
  vboxmanage storageattach hexblade_build \
    --storagectl "SATA" \
    --port 0 \
    --device 0 \
    --type hdd \
    --medium "$(pwd)/../target/vbox/hexblade_build/hexblade_build.vdi"
}

cmd_vm_start() {
  #vboxmanage startvm hexblade_build --type gui
  vboxmanage startvm hexblade_build --type headless
  while ! vboxmanage guestcontrol hexblade_build run --username ubuntu --password hexblade -- /usr/bin/whoami; do
    sleep 5
  done
}

cmd_vm_install() {
  # vboxmanage guestcontrol hexblade_build mkdir --username ubuntu --password hexblade "/tmp/hexblade_vbox"
  # vboxmanage guestcontrol hexblade_build copyto --username ubuntu --password hexblade -R --target-directory "/tmp/hexblade_vbox" "$(pwd)/.."
  vboxmanage guestcontrol hexblade_build run --username ubuntu --password hexblade -E DEBIAN_FRONTEND="noninteractive" -- /usr/bin/sudo -E "umount" /mnt/hexblade/installer || true
  vboxmanage guestcontrol hexblade_build run --username ubuntu --password hexblade -E DEBIAN_FRONTEND="noninteractive" -- /usr/bin/sudo -E "mkdir" -p /mnt/hexblade/installer
  vboxmanage guestcontrol hexblade_build run --username ubuntu --password hexblade -E DEBIAN_FRONTEND="noninteractive" -- /bin/bash -c "echo type=83 | sudo sfdisk /dev/sda"
  vboxmanage guestcontrol hexblade_build run --username ubuntu --password hexblade -E DEBIAN_FRONTEND="noninteractive" -- /usr/bin/sudo -E "mkfs.ext4" -L ROOT /dev/sda1
  vboxmanage guestcontrol hexblade_build run --username ubuntu --password hexblade -E DEBIAN_FRONTEND="noninteractive" -- /usr/bin/sudo -E "mount" /dev/sda1 /mnt/hexblade/installer
  vboxmanage guestcontrol hexblade_build run --username ubuntu --password hexblade -E DEBIAN_FRONTEND="noninteractive" -- /usr/bin/sudo -E "/home/ubuntu/hexblade/cmds/installer-prepare.sh"
  vboxmanage guestcontrol hexblade_build run --username ubuntu --password hexblade -E DEBIAN_FRONTEND="noninteractive" -- /bin/bash -c "echo -e 'us\ny\n\n/dev/sda\nhexblade\nhex\nhex\nhex\n' | /home/ubuntu/hexblade/cmds/config.sh all"
  vboxmanage guestcontrol hexblade_build run --username ubuntu --password hexblade -E DEBIAN_FRONTEND="noninteractive" -- /usr/bin/sudo -E "/home/ubuntu/hexblade/cmds/strap.sh"
  vboxmanage guestcontrol hexblade_build run --username ubuntu --password hexblade -E DEBIAN_FRONTEND="noninteractive" -- /usr/bin/sudo -E "/home/ubuntu/hexblade/cmds/chroot-install.sh"
  vboxmanage guestcontrol hexblade_build run --username ubuntu --password hexblade -E DEBIAN_FRONTEND="noninteractive" -- /usr/bin/sudo -E "/home/ubuntu/hexblade/packages/standard/standard-install.sh"
  vboxmanage guestcontrol hexblade_build run --username ubuntu --password hexblade -E DEBIAN_FRONTEND="noninteractive" -- /usr/bin/sudo -E "apt-get -y install dkms virtualbox-guest-utils"
  vboxmanage guestcontrol hexblade_build run --username ubuntu --password hexblade -E DEBIAN_FRONTEND="noninteractive" -- /usr/bin/sudo -E "/home/ubuntu/hexblade/cmds/boot.sh"
  vboxmanage guestcontrol hexblade_build run --username ubuntu --password hexblade -E DEBIAN_FRONTEND="noninteractive" -- /bin/sync
  vboxmanage guestcontrol hexblade_build run --username ubuntu --password hexblade -E DEBIAN_FRONTEND="noninteractive" -- /usr/bin/sudo -E "umount" /mnt/hexblade/installer || true
}

cmd_vm_export() {
  mkdir -p ../target/ova
  vboxmanage controlvm hexblade_build poweroff
  sleep 5
  vboxmanage modifyvm hexblade_build \
    --memory 1024 \
    --cpus 1
  vboxmanage storageattach hexblade_build \
    --storagectl "IDE" \
    --port 0 \
    --device 1 \
    --type dvddrive \
    --medium "emptydrive"
  vboxmanage export hexblade_build -o ../target/ova/hexblade.ova
}

cmd_build() {
  cmd_clean
  cmd_vm_create
  cmd_vm_start
  cmd_vm_install
  cmd_vm_export
}




cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
