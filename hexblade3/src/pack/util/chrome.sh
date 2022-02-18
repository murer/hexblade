#!/bin/bash -xe

cmd_install() {
    mkdir -p /etc/apt/hardkeys
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub > /etc/apt/hardkeys/google-chrome.list
    echo 'deb [arch=amd64 signed-by=/etc/apt/hardkeys/google-chrome.list] http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google-chrome.list
    apt update
    apt -y install google-chrome-stable
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"

