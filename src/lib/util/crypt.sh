#!/bin/bash -xe

exec "$(dirname "$0")/../crypt/crypt.sh" "$@"
