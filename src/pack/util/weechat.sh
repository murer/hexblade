#!/bin/bash -xe

function cmd_install() {
  [ "x$UID" == "x0" ]
  weechat --version || apt install -y weechat
  [ "x$SUDO_USER" == "x" ] || sudo -u "$SUDO_USER" ./weechat.sh config
}

function cmd_config() {
  weechat -a -r '/server del libera; /quit'
  weechat -a -r '/server add libera irc.libera.chat/6697 -ssl; /quit'
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
