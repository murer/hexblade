#!/bin/bash -xe

cmd_install() {
	if ! openvpn --version  | grep "^OpenVPN"; then
		wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add -
        	echo "deb http://build.openvpn.net/debian/openvpn/release/2.5 focal main" > /etc/apt/sources.list.d/openvpn-aptrepo.list
        	apt-get update
		apt-get install -y openvpn
	fi
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
