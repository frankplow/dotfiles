#!/bin/env bash

killall lemonbar
killall compton
killall -USR1 termite

#if [ $(pgrep qutebrowser | wc -l) -gt 0 ] ; then
#    qutebrowser :config-source
#fi
bash $HOME/.config/bspwm/bspwmrc

spicetify update
