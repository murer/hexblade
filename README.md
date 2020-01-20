# Hex

## Prepare install (live) env

```shell
./cmds/installer-prepare.sh
```

## Partition

Create 2 partitions with ```gdisk /dev/sdX```:

User ```o``` to create a empty gpt table if necessary

```text
Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          821247   400.0 MiB   EF00  EFI System
   2          821248       147621887   70.0 GiB    8300  Linux filesystem
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
sudo lvcreate -L 8G MAIN -n SWAP
sudo lvcreate -l '100%FREE' MAIN -n ROOT
sudo mkfs.ext4 -L ROOT /dev/mapper/MAIN-ROOT
sudo mkswap -L SWAP /dev/mapper/MAIN-SWAP
```

## Mount SWAP and ROOT2

```shell
sudo swapon /dev/mapper/MAIN-SWAP
sudo mkdir -p /mnt/installer
sudo mount /dev/mapper/MAIN-ROOT /mnt/installer
sudo rm -rf /mnt/installer/boot/efi || true
sudo mkdir -p /mnt/installer/boot/efi
```

## Mount EFI

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
./cmds/config-init.sh
```

Edit files in ```target/config``` to configure username, password, etc.

## Install packages

*** MAKE SURE STRAP IS FINISHED ***

./cmds/chroot-install.sh

## Umount

```shell
sudo umount -R /mnt/installer
```

## Reboot into the system

Connect to the internet using command line ```nmcli```

Clone repository and execute:

```shell
./packages/install-all.sh
```
