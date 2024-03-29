#!/bin/bash -xe

[[ "x$UID" != "x0" ]]

# function cmd_vm_ssh_copy_id() {
#     local hex_vm_name="${1?'vm_name'}"
#     local hex_vm_user="${2?'vm_user'}"
#     local hex_ssh_port="$(VBoxManage showvminfo "$hex_vm_name" --machinereadable | grep 'guestssh,tcp' | cut -d',' -f4)"
#     [[ "x$hex_ssh_port" != "x" ]]
#     ssh-copy-id -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 -p "$hex_ssh_port" "$hex_vm_user@localhost"
# }

# function cmd_vm_rsync() {
#     local hex_vm_name="${1?'vm_name'}"
#     local hex_vm_user="${2?'vm_user'}"
#     local hex_vm_src="${3?'src'}"
#     local hex_vm_dst="${4?'dst'}"
#     local hex_ssh_port="$(VBoxManage showvminfo "$hex_vm_name" --machinereadable | grep 'guestssh,tcp' | cut -d',' -f4)"
#     [[ "x$hex_ssh_port" != "x" ]]
#     rsync -av --delete -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 -l $hex_vm_user -p $hex_ssh_port" "$hex_vm_src" "$hex_vm_dst"
# }


# function cmd_vm_ssh() {
#     local hex_vm_name="${1?'vm_name'}"
#     local hex_vm_user="${2?'vm_user'}"
#     shift; shift;   
#     local hex_ssh_port="$(VBoxManage showvminfo "$hex_vm_name" --machinereadable | grep 'guestssh,tcp' | cut -d',' -f4)"
#     [[ "x$hex_ssh_port" != "x" ]]
#     ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 -l "$hex_vm_user" -p "$hex_ssh_port" localhost "$@"
# }

# function cmd_vm_poweroff() {
#     local hex_vm_name="${1?'vm_name'}"
#     VBoxManage controlvm "$hex_vm_name" poweroff
# }

# function cmd_vm_delete() {
#     local hex_vm_name="${1?'vm_name'}"
#     [[ -d "/mnt/hexblade/vbox/$hex_vm_name" ]]
#     VBoxManage unregistervm --delete "$hex_vm_name" || true
#     find "/mnt/hexblade/vbox/$hex_vm_name" -name "disk*.vmdk" | while read k; do
#         VBoxManage closemedium disk "$k" --delete || true
#     done
#     sudo rmdir "/mnt/hexblade/vbox/$hex_vm_name"
# }

# function cmd_vm_create_from_iso() {
#     local hex_vm_iso="${1?'vm_iso'}"
#     local hex_vm_name="${2?'vm_name'}"
#     local hex_vm_ssh="${3?'vm_host_ssh_port_forward'}"
#     [[ ! -d "/mnt/hexblade/vbox/$hex_vm_name" ]]
#     sudo mkdir -p /mnt/hexblade/vbox
#     sudo chown "$USER:$USER" /mnt/hexblade/vbox
#     VBoxManage createvm --name "$hex_vm_name" --ostype "Ubuntu_64" --register --basefolder "/mnt/hexblade/vbox/$hex_vm_name"
#     VBoxManage modifyvm "$hex_vm_name" --ioapic on          
#     VBoxManage modifyvm "$hex_vm_name" --memory 2048 --vram 128      
#     VBoxManage modifyvm "$hex_vm_name" --nic1 nat
#     VBoxManage createhd --filename "/mnt/hexblade/vbox/$hex_vm_name/disk1.vmdk" --size 80000 --format VMDK              
#     VBoxManage storagectl "$hex_vm_name" --name "SATA" --add sata --controller IntelAhci --portcount 1
#     VBoxManage storageattach "$hex_vm_name" --storagectl "SATA" --port 0 --device 0 --type hdd --medium  "/mnt/hexblade/vbox/$hex_vm_name/disk1.vmdk"                
#     VBoxManage storagectl "$hex_vm_name" --name "IDE" --add ide --controller PIIX4       
#     VBoxManage storageattach "$hex_vm_name" --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium "$hex_vm_iso"       
#     VBoxManage modifyvm "$hex_vm_name" --boot1 dvd --boot2 disk --boot3 none --boot4 none 
#     VBoxManage modifyvm "$hex_vm_name" --cpus 2
#     VBoxManage modifyvm "$hex_vm_name" --natpf1 "guestssh,tcp,,$hex_vm_ssh,,22"
# }

# function cmd_vm_start() {
#     local hex_vm_name="${1?'vm_name'}"
#     VBoxManage startvm "$hex_vm_name" --type gui
#     if ! VBoxManage guestproperty wait "$hex_vm_name" "/VirtualBox/GuestInfo/OS/LoggedInUsers" --timeout 180000 --fail-on-timeout; then
#         VBoxManage controlvm "$hex_vm_name" poweroff || true
#         false
#     fi
# }

# function cmd_vm_exec() {
#     local hex_vm_name="${1?'vm_name'}"
#     local hex_vm_timeout="${2?'vm_timeout_ms'}"
#     shift; shift;
#     VBoxManage guestcontrol "$hex_vm_name" --username ubuntu --password ubuntu run --timeout "$hex_vm_timeout" -E DISPLAY=10.0.2.2:0.0 --wait-stdout --wait-stderr -- "$@"
# }

# function cmd_vm_upexec() {
#     local hex_vm_name="${1?'vm_name'}"
#     local hex_vm_file="${2?'file to exec'}"
#     VBoxManage guestcontrol "$hex_vm_name" --username ubuntu --password ubuntu copyto --follow "$hex_vm_file" "/tmp/file"
#     VBoxManage guestcontrol "$hex_vm_name" --username ubuntu --password ubuntu run --timeout 2000 --wait-stdout --wait-stderr -- /usr/bin/chmod -v +x "/tmp/file"
#     VBoxManage guestcontrol "$hex_vm_name" --username ubuntu --password ubuntu run --exe "/tmp/file" --timeout 300000 -E x1=x2 --wait-stdout --wait-stderr
# }



# function cmd_base_gen() {
#     local hex_disk_from="${1?'hex_disk_from'}"
#     local hex_disk_to_name="${2?'hex_disk_to_name'}"
#     mkdir -p gen/vbox/disks
#     VBoxManage clonemedium disk "$hex_disk_from" "gen/vbox/disks/$hex_disk_to_name.vmdk" --format VMDK
# }

# function cmd_vm_disk_list() {
#     VBoxManage list vms | cut -d'"' -f2 | while read k; do
#         VBoxManage showvminfo "$k" --machinereadable | grep '^"SATA-ImageUUID' | cut -d'"' -f4 | awk "{print \"$k:\" \$0}"
#     done
# }

# function cmd_vm_list() {
#     VBoxManage list vms | cut -d'"' -f2
# }

# function cmd_clean() {
#     if [[ -f gen/vbox/_conf/network.id ]]; then
#     local hex_vbox_netid="$(cat gen/vbox/_conf/network.id)"
#         VBoxManage hostonlyif remove "$hex_vbox_netid"
#         rm -v gen/vbox/_conf/network.id
#     fi
# }

# function cmd_setup() {
#     #VBoxManage list hostonlyifs
#     if [[ ! -f gen/vbox/_conf/network.id ]]; then
#         mkdir -p gen/vbox/_conf
#         VBoxManage hostonlyif create  | grep 'Interface' | cut -d "'" -f2 > gen/vbox/_conf/network.id
#         local hex_vbox_netid="$(cat gen/vbox/_conf/network.id)"
#     fi
# }

function cmd_vm_create_from_iso() {
    local hex_vm_name="${1?'vm_name'}"
    local hex_vm_iso="/mnt/hexblade/iso/hexblade.iso"
    [[ ! -d "/mnt/hexblade/vbox/$hex_vm_name" ]]
    [[ -f "$hex_vm_iso" ]]
    sudo mkdir -p /mnt/hexblade/vbox
    sudo chown "$USER:$USER" /mnt/hexblade/vbox
    VBoxManage createvm --name "$hex_vm_name" --ostype "Ubuntu_64" --register --basefolder "/mnt/hexblade/vbox/$hex_vm_name"
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
    # VBoxManage modifyvm "$hex_vm_name" --natpf1 "guestssh,tcp,,$hex_vm_ssh,,22"
}

function cmd_vm_start() {
    local hex_vm_name="${1?'vm_name'}"
    VBoxManage startvm "$hex_vm_name" --type gui
    if ! VBoxManage guestproperty wait "$hex_vm_name" "/VirtualBox/GuestInfo/OS/LoggedInUsers" --timeout 180000 --fail-on-timeout; then
        VBoxManage controlvm "$hex_vm_name" poweroff || true
        false
    fi
}

function cmd_vm_poweroff() {
    local hex_vm_name="${1?'vm_name'}"
    VBoxManage controlvm "$hex_vm_name" poweroff
    sleep 2
}

function cmd_vm_delete() {
    local hex_vm_name="${1?'vm_name'}"
    [[ -d "/mnt/hexblade/vbox/$hex_vm_name" ]]
    VBoxManage unregistervm --delete "$hex_vm_name" || true
    find "/mnt/hexblade/vbox/$hex_vm_name" -name "disk*.vmdk" | while read k; do
        VBoxManage closemedium disk "$k" --delete || true
    done
    sudo rmdir "/mnt/hexblade/vbox/$hex_vm_name"
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"