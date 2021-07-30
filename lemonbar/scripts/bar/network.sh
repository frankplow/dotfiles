#!/usr/bin/env bash

while true
do
    INFO=$(nmcli -t -f active,ssid,signal dev wifi | grep yes)
    if [ ! -z "$INFO" ]; then
        VPN=$(nmcli -t -f state,name conn | grep activated | grep wg0 | wc -l)
        SSID=$(echo $INFO | cut -d: -f2)
        CONN=$(echo $INFO | cut -d: -f3)

        RET="I"
        if [ "$CONN" -lt 33 ]; then
            RET="$RET\ue0ee "
        elif [ "$CONN" -lt 66 ]; then
            RET="$RET\ue0ef "
        else
            RET="$RET\ue0f0 "
        fi

        RET="$RET$SSID"

        if [ "$VPN" ]; then
           RET="$RET\u00b0"
        else
            RET="$RET "
        fi

    fi
    echo -e $RET
    sleep 10
done
