#!/usr/bin/env bash

[ ! -z $(pgrep lemonbar) ] && killall lemonbar
[ ! -z $(pgrep picom) ] && killall picom
# killall -USR1 alacritty

if [ $(pgrep qutebrowser | wc -l) -gt 0 ] ; then
    qutebrowser ':config-source'
fi
$HOME/.config/bspwm/bspwmrc

spicetify update
