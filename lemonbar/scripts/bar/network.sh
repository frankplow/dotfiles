#!/bin/bash

while true
do
    INFO=$(nmcli -t -f active,ssid,signal dev wifi | grep yes)
    SSID=$(echo $INFO | cut -d: -f2)
    CONN=$(echo $INFO | cut -d: -f3)

    echo -n "I"
    if [ "$CONN" -lt 33 ]; then
        echo -ne "\ue0ee "
    elif [ "$CONN" -lt 66 ]; then
        echo -ne "\ue0ef "
    else
        echo -ne "\ue0f0 "
    fi
    echo "$SSID "

    sleep 10
done
