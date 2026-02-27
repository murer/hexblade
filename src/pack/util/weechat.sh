#!/bin/bash -xe

function cmd_install() {
  [ "x$UID" == "x0" ]
  weechat --version || apt install -y weechat
  [ "x$SUDO_USER" == "x" ] || sudo -u "$SUDO_USER" ./weechat.sh config
}

function cmd_config() {
  weechat -a -r '/set irc.server_default.username libera"guest46723678"; /quit'
  weechat -a -r '/set irc.server_default.realname "guest46723678"; /quit'
  weechat -a -r '/set irc.server_default.nicks "guest46723678"; /quit' 
  
  #weechat -a -r '/server del libera; /quit'
  weechat -a -r '/server add libera irc.libera.chat/6697 -ssl; /quit'

  local _libera_user="$(cat "$HOME/.ssh/irc/libera.chat/username.txt")"
  if [ ! -z "$_libera_user" ]; then
    local _libera_pass="$(cat "$HOME/.ssh/irc/libera.chat/password.txt")"
    weechat -a -r "/set irc.server.libera.username \"$_libera_user\"; /quit"
    weechat -a -r "/set irc.server.libera.realname \"$_libera_user\"; /quit"
    weechat -a -r "/set irc.server.libera.nicks \"$_libera_user\"; /quit"
    weechat -a -r "/set irc.server.libera.sasl_mechanism plain; /quit"
    weechat -a -r "/set irc.server.libera.sasl_username \"$_libera_user\"; /quit"
    weechat -a -r "/set irc.server.libera.sasl_password \"$_libera_password\"; /quit"
  fi
  
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
