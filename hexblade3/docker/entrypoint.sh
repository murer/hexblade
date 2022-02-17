#!/bin/bash -xe

xvfb-run -s "$DISPLAY" -s '-screen 0 1024x700x24 -ac' openbox-session
