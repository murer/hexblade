#!/bin/bash -xe

apt $HEXBLADE_APT_ARGS install -y \
        ubiquity \
        ubiquity-casper \
        ubiquity-frontend-gtk \
        ubiquity-slideshow-ubuntu \
        ubiquity-ubuntu-artwork \
        upower
