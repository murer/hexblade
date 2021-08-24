
function cmd_user_add() {
    hexblade_username="${1?'user name is required'}"
    if [[ ! -d "/mnt/hexblade/installer/home/$hexblade_username" ]]; then
        hexblade_password="$2"
        if [ "x$hexblade_password" == "x" ]; then
            hexblade_password="$(openssl passwd -6)"
        elif [ "x$hexblade_password" == "xplain" ] || [ "x$3" != "x" ]; then
            hexblade_password="$(echo -n \"$hexblade_password\" | openssl passwd -6 -stdin)"
        fi
        if [ "x$hexblade_password" == "nopass" ]; then
            arch-chroot /mnt/hexblade/installer useradd -m -G adm,cdrom,sudo,dip,plugdev -s /bin/bash "$hexblade_username"
        else
            arch-chroot /mnt/hexblade/installer useradd -m -G adm,cdrom,sudo,dip,plugdev -s /bin/bash "$hexblade_username" -p "$hexblade_password"
        fi
    fi
}

