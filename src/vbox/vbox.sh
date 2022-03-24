#!/bin/bash -xe

function cmd_vm_delete  () {
    local hex_vm_name="${1?'vm_name'}"
    [[ -d "/mnt/hexblade/vbox/$hex_vm_name" ]]
    VBoxManage unregistervm --delete "$hex_vm_name" || true
    find "/mnt/hexblade/vbox/$hex_vm_name" -name "disk*.vmdk" | while read k; do
        VBoxManage closemedium disk "$k" --delete || true
    done
    rmdir "/mnt/hexblade/vbox/$hex_vm_name"
}

function cmd_vm_create_from_iso() {
    local hex_vm_iso="${1?'vm_iso'}"
    local hex_vm_name="${2?'vm_name'}"
    [[ ! -d "/mnt/hexblade/vbox/$hex_vm_name" ]]
    mkdir -p /mnt/hexblade/vbox
    VBoxManage createvm --name "$hex_vm_name" \
        --ostype "Ubuntu_64" --register --basefolder "/mnt/hexblade/vbox/$hex_vm_name"
    VBoxManage modifyvm "$hex_vm_name" --ioapic on          
    VBoxManage modifyvm "$hex_vm_name" --memory 2048 --vram 128      
    VBoxManage modifyvm "$hex_vm_name" --nic1 nat
    VBoxManage createhd --filename "/mnt/hexblade/vbox/$hex_vm_name/disk1.vmdk" --size 80000 --format VMDK              
    VBoxManage storagectl "$hex_vm_name" --name "SATA" --add sata --controller IntelAhci --portcount 1
    VBoxManage storageattach "$hex_vm_name" --storagectl "SATA" --port 0 --device 0 --type hdd --medium  "/mnt/hexblade/vbox/$hex_vm_name/disk1.vmdk"                
    VBoxManage storagectl "$hex_vm_name" --name "IDE" --add ide --controller PIIX4       
    VBoxManage storageattach "$hex_vm_name" --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium "$hex_vm_iso"       
    VBoxManage modifyvm "$hex_vm_name" --boot1 dvd --boot2 disk --boot3 none --boot4 none 
    VBoxManage modifyvm "$hex_vm_name" --cpus 2
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"