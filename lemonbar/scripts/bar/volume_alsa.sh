#!/bin/env bash

print_volume() {
    VOL=$(amixer -D hw:Device sget PCM | grep Playback | tail -n 1 | cut -d'[' -f2 | tr -d ']%[:space:]')
    MUTE=$(amixer -D hw:Device sget PCM | grep Playback | tail -n 1 | cut -d'[' -f4 | tr -d ']')

    RET="G"
    if [ "$MUTE" == "off" ]; then
        RET="$RET\ue04f "
    elif [ "$VOL" -lt 33 ]; then
        RET="$RET\ue04e "
    elif [ "$VOL" -lt 66 ]; then
        RET="$RET\ue050 "
    else
        RET="$RET\ue05d "
    fi

    RET="$RET$VOL% "
    echo -e $RET
}

print_volume
stdbuf -oL alsactl monitor |
    while read -r line; do
        print_volume
    done
