#!/bin/bash

THEME="$HOME/themes/"$1".theme"
TEMPLATES="$HOME/themes/templates"
ARG=""
for line in $(cat $THEME)
do
    ARG="${ARG} ${HOME}/themes/hashes/${line}.yaml"
done

for line in $(cat $TEMPLATES)
do
    line=$(echo $line | envsubst)
    cat "${line}.mustache" | rzr $ARG > "$line"
done

exec "$HOME/themes/reload.sh" &> /dev/null
