#!/bin/bash -xe

cmd_install() {
	apt -y install --no-install-recommends lxdm

	if [ ! -f /etc/lxdm.original.tar.gz ]; then
		cd /etc
		tar czf lxdm.original.tar.gz lxdm/*
		cd -
	fi

	pwd
	cp -Rv etc/lxdm /etc
	cp -Rv Hexblade /usr/share/lxdm/themes
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
