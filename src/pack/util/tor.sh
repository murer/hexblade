#!/bin/bash -xe

# https://support.torproject.org/apt/tor-deb-repo/

function cmd_install() {
	apt install -y apt-transport-https
	mkdir -p /etc/apt/hardkeys
	wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor > /etc/apt/hardkeys/tor-archive-keyring.gpg
	# wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/hardkeys/packages.microsoft.gpg

	echo 'deb     [signed-by=/etc/apt/hardkeys/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org jammy main' > /etc/apt/sources.list.d/tor.list
   	echo 'deb-src [signed-by=/etc/apt/hardkeys/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org jammy main' >> /etc/apt/sources.list.d/tor.list
	apt update
	apt install -y tor deb.torproject.org-keyring

	# echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/hardkeys/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
	# apt update
	# apt install -y code
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"

