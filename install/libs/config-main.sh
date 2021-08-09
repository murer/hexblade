
function cmd_config_clean() {
    rm -rf /mnt/hexblade/config || true
}

function cmd_config() {
    cmd_config_clean
    mkdir -p /mnt/hexblade
    cp -Rv config /mnt/hexblade
    find /mnt/hexblade/config
}

function cmd_config_hostname() {
    hexblade_config_hostname="$1"
    if [[ "x$hexblade_config_hostname" == "x" ]]; then
    	read -p 'Hostname: ' hexblade_config_hostname
    fi
    [[ "x$hexblade_config_hostname" != "x" ]]
    echo "$hexblade_config_hostname" > /mnt/hexblade/config/basesys/etc/hostname
    echo "127.0.0.1 localhost $hexblade_config_hostname.localdomain $hexblade_config_hostname" > /mnt/hexblade/config/basesys/etc/hosts
    echo "::1 localhost ip6-localhost ip6-loopback" >> /mnt/hexblade/config/basesys/etc/hosts
    echo "ff02::1 ip6-allnodes" >> /mnt/hexblade/config/basesys/etc/hosts
    echo "ff02::2 ip6-allrouters" >> /mnt/hexblade/config/basesys/etc/hosts
}

function cmd_config_all() {
    cmd_config
    cmd_config_hostname
}

