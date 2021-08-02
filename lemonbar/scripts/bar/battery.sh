#!/usr/bin/env bash

CHARGING_FLASH_PERIOD=2
CHARGING_SYMBOL=false

while true
do
    CHARGING=$(cat /sys/class/power_supply/AC/online | tr -d '\n')
    LEVEL=$(cat /sys/class/power_supply/BAT0/capacity | tr -d '\n')

    RET="J"
    if [ $CHARGING -gt 0 ] && [ $CHARGING_SYMBOL = true ]; then
        RET="$RET\u$THEME_SYMBOL_CHARGING "
    elif [ "$LEVEL" -lt 25 ]; then
        RET="$RET\u$THEME_SYMBOL_BATTERY_QUARTER "
    elif [ "$LEVEL" -lt 50 ]; then
        RET="$RET\u$THEME_SYMBOL_BATTERY_HALF "
    elif [ "$LEVEL" -lt 75 ]; then
        RET="$RET\u$THEME_SYMBOL_BATTERY_THREE_QUARTER "
    else
        RET="$RET\u$THEME_SYMBOL_BATTERY_FULL "
    fi

    RET="$RET$LEVEL% "
    echo -e $RET

    if [ $CHARGING_SYMBOL = true ]; then
        CHARGING_SYMBOL=false
    else
        CHARGING_SYMBOL=true
    fi

    sleep $CHARGING_FLASH_PERIOD
done
