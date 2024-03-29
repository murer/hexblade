#!/bin/bash -xe

function cmd_install() {
    mkdir -p /etc/apt/hardkeys
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/hardkeys/google-chrome.gpg
    echo 'deb [arch=amd64 signed-by=/etc/apt/hardkeys/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google-chrome.list
    apt update
    apt -y install google-chrome-stable
}

set +x; cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; set -x; "cmd_${_cmd}" "$@"

