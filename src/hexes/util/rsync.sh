#!/bin/bash -xe

function cmd_rsync() {

   [[ "x$UID" == "x0" ]]

    local hex_src="${1?'hex_src'}"
    local hex_dst="${2?'hex_dst'}"
    local hex_time="${3:-30}"

    echo "$hex_src" | grep "/$" 1>&2
    echo "$hex_dst" | grep "/$" 1>&2

    sync
    while ! timeout "$hex_time" rsync -a --delete -P "$hex_src" "$hex_dst"; do
	sleep 5
    	sync
        sleep 1
    done

    sync
    echo "rsync done" 1>&2
}

set +x; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"
