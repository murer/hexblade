# Hexblade

My own Linux desktop and docker image on top of [Ubuntu](#versions)


[<img src="https://github.com/murer/hexblade/raw/master/docs/Hexblade_Login.png" width="280" />](https://github.com/murer/hexblade)

[![Build Status](https://travis-ci.org/murer/hexblade.svg?branch=master)](https://travis-ci.org/murer/hexblade)

# Features

 * Small and light weight, but functional as any other ubuntu distro
 * ``Openbox`` and ``LXDM`` live iso
 * Full Disk Encryption (including ``/boot``)
 * Dockerhub image with ``xfvb`` and ``vnc`` server
 * Installation script for ```atom```, ```chrome```, ```docker```, ```VirtualBox```, etc

# Live ISO

Download [Hexblade](https://github.com/murer/hexblade/releases/download/edge/hexblade.iso) live and boot into it.

# Docker


https://hub.docker.com/repository/docker/murer/hexblade

```shell
docker run -it -p 5900:5900 murer/hexblade
```

```shell
# apt-get install xtightvncviewer
vncviewer localhost:5900
```

You can find more information about the image on [DOCKER.md](https://github.com/murer/hexblade/blob/master/docs/DOCKER.md)


# Install Hexblade

You can install using Ubuntu Installer on the [Hexblade](https://github.com/murer/hexblade/releases/download/edge/hexblade.iso) live

```shell
sudo ubiquity
```

Or you can install manually

## Manual Installation

This process is about to install Hexblade with **full disk encryption** (including ``/boot``)

Split your disks: [DISK.md](https://github.com/murer/hexblade/blob/master/docs/DISK.md)

### Install MBR

https://github.com/murer/hexblade/blob/master/src/recipe/util/min_crypt_mbr.sh

```shell
./src/recipe/util/min_crypt_mbr.sh from_scratch
```

### Install EFI

https://github.com/murer/hexblade/blob/master/src/recipe/util/min_crypt_efi.sh

```shell
./src/recipe/util/min_lvm_crypt_efi.sh from_scratch
```

## Connect to WIFI using command line

[NETWORK.md](https://github.com/murer/hexblade/blob/master/docs/NETWORK.md)

## Versions

| Version | On top of | Branch |
|---------|-----------|--------|
| 3.x.x | Ubuntu 22.04 | master |
| 2.x.x | Ubuntu 20.04 | ubuntu20 |
| 1.x.x | Ubuntu 18.04 | ubuntu18 |
