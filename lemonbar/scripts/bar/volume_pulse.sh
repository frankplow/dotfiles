#!/usr/bin/bash

pactl subscribe |
    while read -r line; do
        if echo "$line" | grep -q "change" && echo "$line" | grep -q "sink"; then
            echo -n "H"
            VOL=$(pacmd info | grep -im1 -C7 \* | tail -n1 | cut -d'/' -f2 | tr -d '[:space:]%')
            MUTE=$(pacmd info | grep -im1 -C11 \* | tail -n1 | cut -d' ' -f2)

            if [ "$MUTE" == "yes" ]; then
                echo -ne "\ue04f "
            elif [ "$VOL" -lt 33 ]; then
                echo -ne "\ue04e "
            elif [ "$VOL" -lt 66 ]; then
                echo -ne "\ue050 "
            else
                echo -ne "\ue05d "
            fi

            echo "$VOL% "
        fi

    done
