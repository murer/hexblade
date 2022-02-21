# Hexblade

My own Linux desktop and docker image on top of [Ubuntu 20.04](#versions)

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

That is a image you can use to have a desktop inside container.

That would let you run any graphical application without the need to export the screen out.

Additionally you can connect using vnc client any time if you need to see the screen.

Basically it will start hexblade desktop inside xfvb and vnc server.

You can find more information about the image on [HEXBLADE_DOCKER.md](https://github.com/murer/hexblade/blob/master/docs/HEXBLADE_DOCKER.md)

https://hub.docker.com/repository/docker/murer/hexblade

```shell
docker run -it -p 5900:5900 murer/hexblade
```

Connect using any vnc client

```shell
# apt-get install xtightvncviewer
vncviewer localhost:5900
```

# Install Hexblade

You can install using Ubuntu Installer on the [Hexblade](https://github.com/murer/hexblade/releases/download/edge/hexblade.iso) live

```shell
sudo ubiquity
```

Or you can install manually

## Manual Installation

This process is about to install Hexblade with **full disk encryption** (including ``/boot``)

Follow these steps: [INSTALL_MANUAL.md](https://github.com/murer/hexblade/blob/master/docs/INSTALL_MANUAL.md)

## Versions

| Version | On top of | Branch |
|---------|-----------|--------|
| 2.x.x | Ubuntu 20.04 | ubuntu20 master |
| 1.x.x | Ubuntu 18.04 | ubuntu18 |
