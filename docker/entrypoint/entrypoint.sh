#!/bin/bash -xe

ls /opt/hexblade/docker/entrypoint/entrypoint.d | sort | while read k; do
    echo "Exec: $k" 1>&2
    . "/opt/hexblade/docker/entrypoint/entrypoint.d/$k" 1>&2
done

. /opt/hexblade/docker/entrypoint/start.sh
