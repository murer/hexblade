
function cmd_user_add() {
    if [[ ! -d "/mnt/hexblade/installer/home/$user" ]]; then
        hexblade_username="${1?'user name is required'}"
        hexblade_password="$2"
        if [ "x$hexblade_password" == "x" ]; then
            hexblade_password="$(openssl passwd -6)"
        fi
        arch-chroot /mnt/hexblade/installer useradd -m -G adm,cdrom,sudo,dip,plugdev -s /bin/bash "$hexblade_username" -p "$hexblade_password"
    fi
}

