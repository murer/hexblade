# Hex

# Live

https://itnext.io/how-to-create-a-custom-ubuntu-live-from-scratch-dd3b3f213f81

## Prepare install (live) env

I have tested with [Ubuntu 18.04](http://releases.ubuntu.com/18.04/)

Download live source, and boot into it.

***WE WILL NOT PERFORM UBUNTU REGULAR INSTALLATION***

It is more like [Install From Linux](https://help.ubuntu.com/community/Installation/FromLinux)

You need to configure internet access on live system

```shell
sudo ./cmds/installer-prepare.sh
```

## Partition GPT

Create 2 partitions with ```gdisk /dev/sdX```:

Use ```o``` to create a empty gpt table if necessary

```text
Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          821247   400.0 MiB   EF00  EFI System
   9          821248       147621887   70.0 GiB    8300  Linux filesystem
```

## Partition DOS (BIOS)

Create 2 partitions with ```fdisk /dev/sdX```:

Use ```o``` to create a empty mbr table if necessary

```text
Device     Boot Start       End   Sectors  Size Id Type
/dev/sda1        2048 268435455 268433408  128G 83 Linux
```

## Export configs

```shell
export HEX_DEV_EFI=/dev/sda1
export HEX_DEV_LVM=/dev/sda9
```

# Format partitions

 Format EFI if necessary

```shell
sudo mkfs.fat -n ESP -F32 "$HEX_DEV_EFI"
```

LVM on LUKS

```shell
sudo cryptsetup -v -y --type luks --cipher aes-xts-plain64 --hash sha256 luksFormat "$HEX_DEV_LVM"
sudo cryptsetup open "$HEX_DEV_LVM" CRYPTED
sudo pvcreate /dev/mapper/CRYPTED
sudo vgcreate MAIN /dev/mapper/CRYPTED
sudo lvcreate -L 2G MAIN -n BOOT
sudo lvcreate -L 8G MAIN -n SWAP
sudo lvcreate -l '100%FREE' MAIN -n ROOT
sudo mkfs.ext4 -L BOOT /dev/mapper/MAIN-BOOT
sudo mkfs.ext4 -L ROOT /dev/mapper/MAIN-ROOT
sudo mkswap -L SWAP /dev/mapper/MAIN-SWAP
```

## Mount SWAP and ROOT

```shell
sudo swapon /dev/mapper/MAIN-SWAP
sudo mkdir -p /mnt/installer
sudo mount /dev/mapper/MAIN-ROOT /mnt/installer
sudo mkdir -p /mnt/installer/boot
sudo mount /dev/mapper/MAIN-BOOT /mnt/installer/boot
```

## Mount EFI

```shell
sudo rm -rf /mnt/installer/boot/efi || true
sudo mkdir -p /mnt/installer/boot/efi
```

```shell
# Use this if EFI IS NOT already mounted on your installer env
sudo mount "$HEX_DEV_EFI" /mnt/installer/boot/efi

# Use this if EFI IS already mounted on your installer env
sudo mount --bind /boot/efi /mnt/installer/boot/efi
```

## Strap

```shell
./cmds/strap.sh
```

## Configure

You can configure things while strap is running

```shell
./cmds/config.sh all
```

Edit files in ```target/config``` to configure username, password, etc.

## Install hex basic packages

***MAKE SURE STRAP IS FINISHED***

```shell
./cmds/chroot-install.sh
```

## Install packages

```shell
./cmds/chroot-package.sh standard
```

## Install grub

```shell
./cmds/boot.sh
```

## Umount

```shell
sudo umount -R /mnt/installer
```

## Reboot into the system

Connect to the internet using command line ```nmcli```

```shell
nmcli device wifi rescan
nmcli device wifi list
nmcli device wifi connect wifiname password wifipassword
```

Clone repository and execute:

Install optional packages

```shell
./packages/install-all.sh
```
