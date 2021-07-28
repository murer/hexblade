#!/bin/bash -e

[[ "x$UID" != "x0" ]]


cd "$(dirname "$0")" 
_cmd="${1?"cmd is required"}"
shift

set -x
for k in "$(ls libs/*-main.sh | sort)"; do
  . "$k"
done


"cmd_${_cmd}" "$@"
