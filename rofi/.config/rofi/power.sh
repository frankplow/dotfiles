#!/usr/bin/env bash

declare -A options
options["poweroff"]="systemctl poweroff"
options["reboot"]="grub-reboot 0 && systemctl reboot"
options["reboot (windows)"]="grub-reboot 2 && systemctl reboot"
options["exit"]="bspc quit"

for option in "${!options[@]}"; do
    echo $option
done

for option in "${!options[@]}"; do
    if [[ $1 == $option ]]; then
        eval ${options[$option]}
    fi
done
