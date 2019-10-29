#!/usr/bin/bash

while true
do
    LEVEL=$(cat /sys/class/power_supply/BAT0/capacity | tr -d '\n')

    RET="J"
    if [ "$LEVEL" -lt 25 ]; then
        RET="$RET\ue038 "
    elif [ "$LEVEL" -lt 50 ]; then
        RET="$RET\ue039 "
    elif [ "$LEVEL" -lt 75 ]; then
        RET="$RET\ue03a "
    else
        RET="$RET\ue03b "
    fi

    RET="$RET$LEVEL% "
    echo -e $RET

    sleep 10
done
