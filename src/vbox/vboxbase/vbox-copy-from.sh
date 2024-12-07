#!/bin/bash -xe

VBoxManage guestcontrol personal2 copyfrom --target-directory /tmp/hexblade.vdi --username hex --password hex /mnt/hexbase/out.vdi
mv -v /tmp/hexblade.vdi /ssd1/vbox/murer/vms/hexblade.vdi

