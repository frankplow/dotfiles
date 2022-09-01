#!/usr/bin/env bash

CMD='setxkbmap -option caps:super'
eval $CMD
udevadm monitor -u -s input |
grep --line-buffered add |
while read -r event; do
    eval $CMD
done
