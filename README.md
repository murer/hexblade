# Hexblade

<img src="https://github.com/murer/hexblade/raw/master/Docs/HexbladeGitHub.png" width="280" />

That is my own Linux on top of Ubuntu

[![Build Status](https://travis-ci.org/murer/hexblade.svg?branch=master)](https://travis-ci.org/murer/hexblade)

# Live

Download [Hexblade](https://github.com/murer/hexblade/releases/download/edge/hexblade.iso) live and boot into it.

# Install

You can install using Ubuntu Installer on the [Hexblade](https://github.com/murer/hexblade/releases/download/edge/hexblade.iso) live

```shell
sudo ubiquity
```

Or you can install manually

## Manual Installation

This process is about to install Hexblade with **full disk encryption** (including ``/boot``)

You should follow these steps on the [Hexblade](https://github.com/murer/hexblade/releases/download/edge/hexblade.iso) live or [Ubuntu 18.04](http://releases.ubuntu.com/18.04/) live

You need to configuring internet access on live system

### Hexblade Source

There should exists a clone on ``$HOME/hexblade``. If it was not there, clone it:

```shell
cd "$HOME"
git clone https://github.com/murer/hexblade
cd hexblade
```

### Install required packages on live system

```shell
sudo ./cmds/installer-prepare.sh
```

### Partition GPT

Create 2 partitions with ```gdisk /dev/sdX```:

Use ```o``` to create a empty gpt table if necessary

```text
Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          821247   400.0 MiB   EF00  EFI System
   9          821248       147621887   70.0 GiB    8300  Linux filesystem
```

### Partition DOS (BIOS)

Create 1 partition with ```fdisk /dev/sdX```:

Use ```o``` to create a empty mbr table if necessary

```text
Device     Boot Start       End   Sectors  Size Id Type
/dev/sda1        2048 268435455 268433408  128G 83 Linux
```

## Export configs

```shell
export HEXBLADE_DEV_EFI=/dev/sda1
export HEXBLADE_DEV_LVM=/dev/sda9
```

### Format partitions

 Format EFI if necessary

```shell
sudo mkfs.fat -n ESP -F32 "$HEXBLADE_DEV_EFI"
```

LVM on LUKS

```shell
sudo cryptsetup -v -y --type luks --cipher aes-xts-plain64 --hash sha256 luksFormat "$HEXBLADE_DEV_LVM"
sudo cryptsetup open "$HEXBLADE_DEV_LVM" CRYPTED
sudo pvcreate /dev/mapper/CRYPTED
sudo vgcreate MAIN /dev/mapper/CRYPTED
sudo lvcreate -L 2G MAIN -n BOOT
sudo lvcreate -L 8G MAIN -n SWAP
sudo lvcreate -l '100%FREE' MAIN -n ROOT
sudo mkfs.ext4 -L BOOT /dev/mapper/MAIN-BOOT
sudo mkfs.ext4 -L ROOT /dev/mapper/MAIN-ROOT
sudo mkswap -L SWAP /dev/mapper/MAIN-SWAP
```

### Mount SWAP and ROOT

```shell
sudo swapon /dev/mapper/MAIN-SWAP
sudo mkdir -p /mnt/hexblade/installer
sudo mount /dev/mapper/MAIN-ROOT /mnt/hexblade/installer
sudo mkdir -p /mnt/hexblade/installer/boot
sudo mount /dev/mapper/MAIN-BOOT /mnt/hexblade/installer/boot
```

## Mount EFI

```shell
sudo rm -rf /mnt/hexblade/installer/boot/efi || true
sudo mkdir -p /mnt/hexblade/installer/boot/efi
```

```shell
# Use this if EFI IS NOT already mounted on your installer env
sudo mount "$HEXBLADE_DEV_EFI" /mnt/hexblade/installer/boot/efi

# Use this if EFI IS already mounted on your installer env
sudo mount --bind /boot/efi /mnt/hexblade/installer/boot/efi
```

### Strap

```shell
./cmds/strap.sh
```

## Configure

You can configure things while strap is running

```shell
./cmds/config.sh all
```

Edit files in ```target/config``` to configure username, password, etc.

### Install hexblade basic packages

***MAKE SURE STRAP IS FINISHED***

```shell
./cmds/chroot-install.sh
```

### Install packages

```shell
./cmds/chroot-package.sh standard
```

### Install grub

```shell
./cmds/boot.sh
```

### Umount

```shell
sudo umount -R /mnt/hexblade/installer
```

### Reboot into the system

You can connect to the internet using command line ```nmcli``` if you do not install any graphical way to do this

```shell
nmcli device wifi rescan
nmcli device wifi list
nmcli device wifi connect wifiname password wifipassword
```

There should exists a clone on ``$HOME/hexblade``. If it was not there, clone it:

```shell
cd "$HOME"
git clone https://github.com/murer/hexblade
cd hexblade
```

Install optional packages

```shell
ls packages
# sample: ./packages/install-docker.sh
```

You can remove the Hexblade Source

```shell
rm -rf "$HOME/hexblade"
```
