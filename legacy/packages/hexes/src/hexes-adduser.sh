#!/bin/bash -xe

hexes_username="${1?'username'}"

if [[ ! -d "/home/$hexes_username" ]]; then

    useradd -m -G video -s /usr/sbin/nologin "$hexes_username"

    echo "xhost '+SI:localuser:$hexes_username'" > "/etc/xdg/openbox/autostart.d/20-xhost-user-$hexes_username.sh"

    mkdir -p "/localdata/$hexes_username/config/google-chrome"
    mkdir "/home/$hexes_username/.config"
    ln -s "/localdata/$hexes_username/config/google-chrome" "/home/$hexes_username/.config/google-chrome"
    chown -R "$hexes_username:$hexes_username" "/home/$hexes_username" "/localdata/$hexes_username"

    xhost "+SI:localuser:$hexes_username"
fi