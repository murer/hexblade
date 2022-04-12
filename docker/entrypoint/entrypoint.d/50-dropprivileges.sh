#!/bin/bash -xe

if [[ "x$HEX_DROP_PRIVILEGES" == "xtrue" ]]; then
    sudo gpasswd --delete "$(whoami)" adm
    sudo gpasswd --delete "$(whoami)" cdrom
    sudo gpasswd --delete "$(whoami)" sudo
    sudo gpasswd --delete "$(whoami)" dip
    sudo gpasswd --delete "$(whoami)" plugdev
    sudo gpasswd --delete "$(whoami)" supersudo
fi
