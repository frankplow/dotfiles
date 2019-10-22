#!/usr/bin/bash

LEVEL=$(cat /sys/class/power_supply/BAT0/capacity | tr -d '\n')

echo -n "J"
if [ "$LEVEL" -lt 25 ]; then
	echo -ne "\ue038 "
elif [ "$LEVEL" -lt 50 ]; then
	echo -ne "\ue039 "
elif [ "$LEVEL" -lt 75 ]; then
	echo -ne "\ue03a "
else
	echo -ne "\ue03b "
fi

echo "$LEVEL% "
