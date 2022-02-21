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

	update-alternatives --install /etc/lxdm/default.conf lxdm.conf /etc/lxdm/lxdm-hexblade.conf 30
	update-alternatives --set lxdm.conf /etc/lxdm/lxdm-hexblade.conf
}

cmd_noautologin() {
	crudini --del /etc/lxdm/lxdm-hexblade.conf base autologin
}

cmd_autologin() {
	hexblade_autologin="${1?'username'}"
	crudini --set /etc/lxdm/lxdm-hexblade.conf base autologin "$hexblade_autologin"
}

cmd_tcplisten() {
	hexblade_tcplisten="${1?'enable or disable'}"
	if [[ "x$hexblade_tcplisten" == "xenable" ]]; then
		crudini --set /etc/lxdm/lxdm-hexblade.conf server arg "/usr/bin/X +iglx -listen tcp"
		crudini --set /etc/lxdm/lxdm-hexblade.conf server tcp_listen "1"
	elif [[ "x$hexblade_tcplisten" == "xdisable" ]]; then
		crudini --del /etc/lxdm/lxdm-hexblade.conf server arg
		crudini --del /etc/lxdm/lxdm-hexblade.conf server tcp_listen
	else
		false
	fi
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
