#!/bin/bash -xe

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt $hexblade_apt_argsupdate
sudo apt $hexblade_apt_args-y install google-chrome-stable
