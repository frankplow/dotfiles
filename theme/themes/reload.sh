#!/bin/bash

killall lemonbar
killall sxhkd
killall compton
killall -USR1 termite
if [ $(pgrep qutebrowser | wc -l) -gt 0 ] ; then
    qutebrowser :config-source
fi
bash ~/.config/bspwm/bspwmrc
