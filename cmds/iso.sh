#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

cd /mnt
mkdir -p image/{casper,isolinux,install}
sudo cp installer/boot/vmlinuz-**-**-generic image/casper/vmlinuz
sudo cp installer/boot/initrd.img-**-**-generic image/casper/initrd
