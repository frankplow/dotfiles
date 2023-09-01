#!/usr/bin/env bash

sleep 1

monitor_from=$(bspc query -M -m focused)

for monitor in $(bspc query -M); do
    if [ $monitor = $monitor_from ]; then
        continue
    fi

    bspc monitor $monitor_from -a tmp
    for desktop in $(bspc query -D -m $monitor_from); do
        bspc desktop $desktop -m $monitor --follow
    done
    bspc desktop Desktop -r
    bspc desktop tmp -n Desktop
done

sleep 1

killall lemonbar; lemonbar.sh &
feh --bg-scale /home/frank/pictures/backgrounds/blur_dark.jpg
