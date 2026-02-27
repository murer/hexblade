#!/bin/bash -xe

function cmd_install() {
  [ "x$UID" == "x0" ]
  weechat --version || apt install -y weechat
  [ "x$SUDO_USER" == "x" ] || sudo -u "$SUDO_USER" ./weechat.sh config
}

function cmd_config() {
  weechat -a -r '/set irc.ctcp.version ""; /quit'
  weechat -a -r '/set irc.ctcp.ping ""; /quit'
  weechat -a -r '/set irc.ctcp.time ""; /quit'
  weechat -a -r '/set irc.ctcp.finger ""; /quit'
  weechat -a -r '/set irc.ctcp.userinfo ""; /quit'
  weechat -a -r '/set irc.ctcp.source ""; /quit'
  weechat -a -r '/set irc.ctcp.clientinfo ""; /quit'
  weechat -a -r '/set irc.ctcp.action ""; /quit'
  weechat -a -r '/set irc.ctcp.dcc ""; /quit'

  weechat -a -r '/set irc.server_default.username "guest46723678"; /quit'
  weechat -a -r '/set irc.server_default.realname "guest46723678"; /quit'
  weechat -a -r '/set irc.server_default.nicks "guest46723678"; /quit' 
  
  #weechat -a -r '/server del libera; /quit'
  weechat -a -r '/server add libera irc.libera.chat/6697 -ssl; /quit'

  local _libera_pass="$(cat "$HOME/.ssh/irc/libera.chat/password.txt")"
  if [ ! -z "$_libera_pass" ]; then
    local _libera_user="$(cat "$HOME/.ssh/irc/libera.chat/username.txt")"
    weechat -a -r "/set irc.server.libera.username \"$_libera_user\"; /quit"
    weechat -a -r "/set irc.server.libera.realname \"$_libera_user\"; /quit"
    weechat -a -r "/set irc.server.libera.nicks \"$_libera_user\"; /quit"
    weechat -a -r "/set irc.server.libera.sasl_mechanism plain; /quit"
    weechat -a -r "/set irc.server.libera.sasl_username \"$_libera_user\"; /quit"
    weechat -a -r "/set irc.server.libera.sasl_password \"$_libera_pass\"; /quit"
  fi

  local _libera_pubkey="$(cat "$HOME/.ssh/irc/libera.chat/pubkey.txt")"
  if [ ! -z "$_libera_pubkey" ]; then
    [ -f "$HOME/.ssh/irc/libera.chat/ecdsa.pem" ]
    weechat -a -r "/set irc.server.libera.sasl_mechanism ecdsa-nist256p-challenge; /quit"
    weechat -a -r '/set irc.server.libera.sasl_key "${env:HOME}/.ssh/irc/libera.chat/ecdsa.pem"; /quit'
  fi

  weechat -a -r '/server add hackint irc.hackint.org/6697 -ssl; /quit'
  
  
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
