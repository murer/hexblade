#!/bin/bash -xe

function cmd_rsync() {

   [[ "x$UID" == "x0" ]]

    local hex_src="${1?'hex_src'}"
    local hex_dst="${2?'hex_dst'}"
    local hex_time="${3:-30}"
    local hex_sleep="${4:-5}"

    echo "$hex_src" | grep "/$" 1>&2
    echo "$hex_dst" | grep "/$" 1>&2

    hex_progress="-P"

    sync
    while ! timeout "$hex_time" rsync -a --delete $hex_progress "$hex_src" "$hex_dst"; do
	sleep "$hex_sleep"
    	date
	sync
	date
        sleep 0.3
	du -hs "$hex_src" "$hex_dst"
	[[ ! -f bakstop ]]
	#if [[ "x$hex_progress" == "x-P" ]]; then
	#	hex_progress="--info=progress2"
	#else
		hex_progress="-P"
	#fi
    done

    sync
    echo "rsync done" 1>&2
}

set +x; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"
