#!/usr/bin/bash

print_volume() {
    VOL=$(amixer -D hw:Device sget PCM | grep Playback | tail -n 1 | cut -d'[' -f2 | tr -d ']%[:space:]')
    MUTE=$(amixer -D hw:Device sget PCM | grep Playback | tail -n 1 | cut -d'[' -f4 | tr -d ']')

    echo -ne "G"
    if [ "$MUTE" == "off" ]; then
        echo -ne "\ue04f "
    elif [ "$VOL" -lt 33 ]; then
        echo -ne "\ue04e "
    elif [ "$VOL" -lt 66 ]; then
        echo -ne "\ue050 "
    else
        echo -ne "\ue05d "
    fi

    echo "$VOL% "
}

print_volume
stdbuf -oL alsactl monitor |
    while read -r line; do
        print_volume
    done
