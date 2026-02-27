#!/bin/bash -xe

function cmd_install() {
  [[ "x$UID" == "x0" ]]
  
  apt install -y weechat

  weechat -a -r '/server del libera; /quit'
  weechat -a -r '/server add libera irc.libera.chat/6697 -ssl'
  
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
