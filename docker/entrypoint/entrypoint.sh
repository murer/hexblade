#!/bin/bash -xe

# if [[ "x$HEX_REGROUP" == "x" ]]; then
#     export HEX_REGROUP="$(id -g)"
# fi
# if [[ "x$HEX_REUSER" == "x" ]]; then
#     export HEX_REUSER="$(id -u)"
# fi

# if [[ "x$HEX_REUSER" != "x$(id -u)" ]] || [[ "x$HEX_REGROUP" != "x$(id -g)" ]]; then
#     sudo groupadd -g "$HEX_REGROUP" thex || true
#     sudo useradd -u "$HEX_REUSER" -g "$HEX_REGROUP" -m -G adm,cdrom,sudo,supersudo,dip,plugdev -s /bin/bash thex || true
#     sudo usermod -aG "$HEX_REGROUP" "$(getent passwd "$HEX_REUSER" | cut -d: -f1)" || true
    
#     cd "/home/$(getent passwd "$HEX_REUSER" | cut -d: -f1)" || true
#     export HOME="$(pwd)"
#     export HEX_DOCKER_REUSER=true
#     sudo -Eu "#$HEX_REUSER" -g "#$HEX_REGROUP" "$0" "$@"
# fi

ls /opt/hexblade/docker/entrypoint/entrypoint.d | sort | while read k; do
    echo "Exec: $k"
    . "/opt/hexblade/docker/entrypoint/entrypoint.d/$k"
done



