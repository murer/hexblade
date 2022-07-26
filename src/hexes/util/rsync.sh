#!/bin/bash -xe

function cmd_rsync() {
    local hex_src="${1?'hex_src'}"
    local hex_dst="${2?'hex_dst'}"
    local hex_time="${3:-30}"

    echo "$hex_src" | grep "/$" 1>&2
    echo "$hex_dst" | grep "/$" 1>&2

    sync
    while ! timeout "$hex_time" rsync -a --delete -P "$hex_src" "$hex_dst"; do
        sync
        sleep 2
    done

    echo "rsync done" 1>&2
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"
