#!/bin/bash -xe

xvfb-run -s "$DISPLAY" -s '-screen 0 1024x700x24 -ac' openbox-session

#Xvfb "$DISPLAY" -screen 0 1024x768x24 -ac &
#sleep 2
#openbox --startup /etc/X11/openbox/autostart &
#openbox-session &
#x11vnc -display :99 -forever -nopw
