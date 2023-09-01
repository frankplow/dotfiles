#!/usr/bin/env bash

# merge variables
xrdb -merge ~/.Xresources
# dbus-update-activation-environment --systemd --all

# sleep
xset s 300 5
xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock &
