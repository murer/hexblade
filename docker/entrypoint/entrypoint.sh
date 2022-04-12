#!/bin/bash -xe

ls /opt/hexblade/docker/entrypoint/entrypoint.d | sort | while read k; do
    echo "Exec: $k"
    . "/opt/hexblade/docker/entrypoint/entrypoint.d/$k"
done
