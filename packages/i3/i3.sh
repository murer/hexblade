#!/bin/bash -xe

cmd_install() {
	apt -y install xorg i3 xautolock arandr xinit

	if [ ! -f /etc/i3.original.tar.gz ]; then
		cd /etc
		tar czf i3.original.tar.gz i3
		rm -rfv i3
		cd -
	fi

	cp -TRv etc/i3 /etc/i3
}

cmd_xinit() {
	cp -v home/xinitrc ~/.xinitrc
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
