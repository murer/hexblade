#!/bin/bash -xe

[[ "x$USER" != "xmurer" ]]
[[ "x$USER" != "xroot" ]]

export DISPLAY=:0.0
export PULSE_SERVER=127.0.0.1:4713

cmd_chrome() {
	(google-chrome &)
}

cmd_bash() {
	bash "$@"
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"

