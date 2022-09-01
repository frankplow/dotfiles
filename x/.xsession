#!/usr/bin/env bash

# merge variables
xrdb -merge ~/.Xresources
# dbus-update-activation-environment --systemd --all

# keyboard setup
caps_to_super.sh &

# sleep
xset s off
xset +dpms
xset dpms 0 0 0
# xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock &
xidlehook --not-when-fullscreen \
    --timer 300 'xsecurelock' '' \
    --timer 120 'xset force standby' '' \
    --timer 1380 'systemctl suspend' '' &
