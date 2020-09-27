#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

cd /mnt
rm -rf  image || true
mkdir -p image/{casper,isolinux,install}
cp installer/boot/vmlinuz-**-**-generic image/casper/vmlinuz
cp installer/boot/initrd.img-**-**-generic image/casper/initrd

touch image/ubuntu

cat > image/isolinux/grub.cfg <<-EOF

search --set=root --file /ubuntu

insmod all_video

set default="0"
set timeout=30

menuentry "Hexblade Live" {
   linux /casper/vmlinuz boot=casper verbose nosplash ---
   initrd /casper/initrd
}

menuentry "Install Hexblade" {
   linux /casper/vmlinuz boot=casper only-ubiquity verbose nosplash ---
   initrd /casper/initrd
}

menuentry "Check disc for defects" {
   linux /casper/vmlinuz boot=casper integrity-check verbose nosplash ---
   initrd /casper/initrd
}

# menuentry "Test memory Memtest86+ (BIOS)" {
#    linux16 /install/memtest86+
# }
#
# menuentry "Test memory Memtest86 (UEFI, long load time)" {
#    insmod part_gpt
#    insmod search_fs_uuid
#    insmod chain
#    loopback loop /install/memtest86
#    chainloader (loop,gpt1)/efi/boot/BOOTX64.efi
# }
EOF

arch-chroot /mnt/installer dpkg-query -W --showformat='${Package} ${Version}\n' | tee image/casper/filesystem.manifest
cp -v image/casper/filesystem.manifest image/casper/filesystem.manifest-desktop
sed -i '/ubiquity/d' image/casper/filesystem.manifest-desktop
sed -i '/casper/d' image/casper/filesystem.manifest-desktop
sed -i '/discover/d' image/casper/filesystem.manifest-desktop
sed -i '/laptop-detect/d' image/casper/filesystem.manifest-desktop
sed -i '/os-prober/d' image/casper/filesystem.manifest-desktop

mksquashfs installer image/casper/filesystem.squashfs
printf $(du -sx --block-size=1 installer | cut -f1) > image/casper/filesystem.size

cd -
