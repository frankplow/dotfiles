#!/bin/bash

[ -f /etc/xprofile ] && . /etc/xprofile
[ -f $HOME/.xprofile ] && . $HOME/.xprofile
[ -f $HOME/.Xresources ] && . $HOME/.Xresources

export WIDTH=$(xrandr | tr , $'\n' | grep current | cut -d' ' -f3)
export HEIGHT=$(xrandr | tr , $'\n' | grep current | cut -d' ' -f5)

#/opt/urserver/urserver --daemon
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &

setxkbmap gb

exec bspwm
