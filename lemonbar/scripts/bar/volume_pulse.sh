#!/usr/bin/bash

pactl subscribe |
    while read -r line; do
        if echo "$line" | grep -q "change" && echo "$line" | grep -q "sink"; then
            RET="H"
            VOL=$(pacmd info | grep -im1 -C7 \* | tail -n1 | cut -d'/' -f2 | tr -d '[:space:]%')
            MUTE=$(pacmd info | grep -im1 -C11 \* | tail -n1 | cut -d' ' -f2)

            if [ "$MUTE" == "yes" ]; then
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
        fi

    done
