#!/bin/bash -xe

cmd_up() {
  brightnessctl set '+10000'
  notify-send -i display -t 500 "$(brightnessctl)" 
}

cmd_down() {
  brightnessctl set '10000-'
  notify-send -i display -t 500 "$(brightnessctl)"
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"

