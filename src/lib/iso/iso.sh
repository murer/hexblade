#!/bin/bash -xe

# https://github.com/mvallim/live-custom-ubuntu-from-scratch

function cmd_install() {
    
  arch-chroot /mnt/hexblade/system apt install -y \
    casper \
    lupin-casper \
    discover \
    laptop-detect \
    os-prober \
    upower \
    dkms
    #virtualbox-guest-utils

  #arch-chroot /mnt/hexblade/system apt install -y \
  # ubiquity \
  # ubiquity-casper \
  # ubiquity-frontend-gtk \
  # ubiquity-slideshow-ubuntu \
  # ubiquity-ubuntu-artwork \

  #arch-chroot /mnt/hexblade/system apt install -y \
  #  virtualbox-guest-dkms \
  #  virtualbox-guest-x11

  if [[ "x$HEXBLADE_LIVE_DISABLE_ADDUSER" == "xtrue" ]]; then
    chmod -x /mnt/hexblade/system/usr/share/initramfs-tools/scripts/casper-bottom/25adduser
    ../util/boot.sh initramfs
  fi

  arch-chroot /mnt/hexblade/system apt clean
  mkdir -p /mnt/hexblade/image/casper
  cp /mnt/hexblade/system/boot/vmlinuz-**-**-generic /mnt/hexblade/image/casper/vmlinuz
  cp /mnt/hexblade/system/boot/initrd.img-**-**-generic /mnt/hexblade/image/casper/initrd
  touch /mnt/hexblade/image/ubuntu

  arch-chroot /mnt/hexblade/system dpkg-query -W --showformat='${Package} ${Version}\n' > /mnt/hexblade/image/casper/filesystem.manifest
  cp -v /mnt/hexblade/image/casper/filesystem.manifest /mnt/hexblade/image/casper/filesystem.manifest-desktop
  sed -i '/ubiquity/d' /mnt/hexblade/image/casper/filesystem.manifest-desktop
  sed -i '/casper/d' /mnt/hexblade/image/casper/filesystem.manifest-desktop
  sed -i '/discover/d' /mnt/hexblade/image/casper/filesystem.manifest-desktop
  sed -i '/laptop-detect/d' /mnt/hexblade/image/casper/filesystem.manifest-desktop
  sed -i '/os-prober/d' /mnt/hexblade/image/casper/filesystem.manifest-desktop
  sed -i '/virtualbox-guest-utils/d' /mnt/hexblade/image/casper/filesystem.manifest-desktop
  sed -i '/virtualbox-guest-x11/d' /mnt/hexblade/image/casper/filesystem.manifest-desktop
  sed -i '/virtualbox-guest-dkms/d' /mnt/hexblade/image/casper/filesystem.manifest-desktop
}

function cmd_compress() {
  rm /mnt/hexblade/image/casper/filesystem.squashfs || true
  mksquashfs /mnt/hexblade/system /mnt/hexblade/image/casper/filesystem.squashfs
  printf $(du -sx --block-size=1 /mnt/hexblade/system | cut -f1) > /mnt/hexblade/image/casper/filesystem.size
  cp resources/README.diskdefines /mnt/hexblade/image/README.diskdefines
}

function cmd_iso() {
  mkdir -p /mnt/hexblade/image/isolinux
  cp resources/grub.cfg /mnt/hexblade/image/isolinux/grub.cfg


  mkdir -p /mnt/hexblade/iso
  cd /mnt/hexblade/image
  grub-mkstandalone \
   --format=x86_64-efi \
   --output=isolinux/bootx64.efi \
   --locales="" \
   --fonts="" \
   "boot/grub/grub.cfg=isolinux/grub.cfg"
  cd -

  cd /mnt/hexblade/image/isolinux
  dd if=/dev/zero of=efiboot.img bs=1M count=10
  sudo mkfs.vfat efiboot.img
  LC_CTYPE=C mmd -i efiboot.img efi efi/boot
  LC_CTYPE=C mcopy -i efiboot.img ./bootx64.efi ::efi/boot/
  cd -
  
  cd /mnt/hexblade/image
  grub-mkstandalone \
    --format=i386-pc \
    --output=isolinux/core.img \
    --install-modules="linux16 linux normal iso9660 biosdisk memdisk btrfs lvm video ntfs squash4 serial usb cat ls search tar ls reboot halt crypto cryptodisk" \
    --modules="linux16 linux normal iso9660 biosdisk search" \
    --locales="" \
    --fonts="" \
    "boot/grub/grub.cfg=isolinux/grub.cfg"
  cat /usr/lib/grub/i386-pc/cdboot.img isolinux/core.img > isolinux/bios.img
  find . -type f -print0 | xargs -0 md5sum | grep -v -e 'md5sum.txt' -e 'bios.img' -e 'efiboot.img' | tee md5sum.txt

  xorriso \
    -as mkisofs \
    -iso-level 3 \
    -full-iso9660-filenames \
    -volid "Ubuntu from scratch" \
    -eltorito-boot boot/grub/bios.img \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    --eltorito-catalog boot/grub/boot.cat \
    --grub2-boot-info \
    --grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img \
    -eltorito-alt-boot \
    -e EFI/efiboot.img \
    -no-emul-boot \
    -append_partition 2 0xef isolinux/efiboot.img \
    -output "../iso/hexblade.iso" \
    -graft-points \
        "." \
        /boot/grub/bios.img=isolinux/bios.img \
        /EFI/efiboot.img=isolinux/efiboot.img  

  # xorriso \
  #  -as mkisofs \
  #  -iso-level 3 \
  #  -full-iso9660-filenames \
  #  -volid "Ubuntu from scratch" \
  #  -output "../ubuntu-from-scratch.iso" \
  #  -eltorito-boot boot/grub/bios.img \
  #     -no-emul-boot \
  #     -boot-load-size 4 \
  #     -boot-info-table \
  #     --eltorito-catalog boot/grub/boot.cat \
  #     --grub2-boot-info \
  #     --grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img \
  #  -eltorito-alt-boot \
  #     -e EFI/efiboot.img \
  #     -no-emul-boot \
  #  -append_partition 2 0xef isolinux/efiboot.img \
  #  -m "isolinux/efiboot.img" \
  #  -m "isolinux/bios.img" \
  #  -graft-points \
  #     "/EFI/efiboot.img=isolinux/efiboot.img" \
  #     "/boot/grub/bios.img=isolinux/bios.img" \
      # "."

  cd -
  
}

function cmd_sha256() {
  cd /mnt/hexblade/iso
  sha256sum -b hexblade.iso > hexblade.SHA256
  cd -
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"