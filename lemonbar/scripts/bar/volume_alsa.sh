#!/usr/bin/env bash

print_volume() {
    VOL=$(amixer -D hw:PCH sget Master | grep Playback | tail -n 1 | cut -d'[' -f2 | tr -d ']%[:space:]')
    MUTE=$(amixer -D hw:PCH sget Master | grep Playback | tail -n 1 | cut -d'[' -f4 | tr -d ']')

    RET="G"
    if [ "$MUTE" == "off" ]; then
        RET="$RET\u$THEME_SYMBOL_VOLUME_MUTE "
    elif [ "$VOL" -lt 33 ]; then
        RET="$RET\u$THEME_SYMBOL_VOLUME_OFF "
    elif [ "$VOL" -lt 66 ]; then
        RET="$RET\u$THEME_SYMBOL_VOLUME_LOW "
    else
        RET="$RET\u$THEME_SYMBOL_VOLUME_HIGH "
    fi

    RET="$RET$VOL% "
    echo -e $RET
}

print_volume
stdbuf -oL alsactl monitor |
    while read -r line; do
        print_volume
    done
