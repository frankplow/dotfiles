#!/bin/bash

emulate sh
. $HOME/.profile
emulate zsh

export DBUS_SESSION_ADDRESS=$(xargs --null --max-args=1 < /proc/$(pidof bspwm)/environ | grep DBUS_SESSION_BUS_ADDRESS)
