# Hexblade

<img src="https://github.com/murer/hexblade/raw/master/docs/Hexblade_Login.png" width="280" />

That is my own Linux on top of Ubuntu

[![Build Status](https://travis-ci.org/murer/hexblade.svg?branch=master)](https://travis-ci.org/murer/hexblade)

# Features

 * Small and light weight, but functional as any other ubuntu distro
 * ``Openbox`` and ``LXDM`` live iso
 * Full Disk Encryption (including ``/boot``)
 * Text-only live iso (not ready yet)
 * Dockerhub image with ``xfvb`` and ``vnc`` server
 * Installation script for ```atom```, ```chrome```, ```docker```, ```VirtualBox```, etc

# Live ISO

Download [Hexblade](https://github.com/murer/hexblade/releases/download/edge/hexblade.iso) live and boot into it.

# Docker

Start docker

```shell
docker run -it -p 5900:5900 murer/hexblade
```

And connect to it:

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
