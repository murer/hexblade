
function cmd_config_clean() {
    rm -rf /mnt/hexblade/config || true
}

function cmd_config() {
    cmd_config_clean
    mkdir -p /mnt/hexblade
    cp -Rv config /mnt/hexblade

    find /mnt/hexblade/config
}
