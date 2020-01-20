#!/bin/bash -xe

[[ "x$UID" == "x0" ]]

debootstrap bionic /mnt/installer
