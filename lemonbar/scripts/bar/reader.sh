#!/bin/env bash

while read -r line; do
    case $line in
        A*)
            arch=${line#?}
            ;;
        B*)
            bspwm=${line#?}
            ;;
        C*)
            clock=${line#?}
            ;;
        D*)
            date=${line#?}
            ;;
        E*)
            power=${line#?}
            ;;
        F*)
            spotify=${line#?}
            ;;
        G*)
            volume_alsa=${line#?}
            ;;
        H*)
            volume_pulse=${line#?}
            ;;
        I*)
            network=${line#?}
            ;;
        J*)
            battery=${line#?}
            ;;
    esac
    echo "%{l}${arch}${bspwm}%{c}${spotify}%{r}${volume_alsa} ${date} ${clock} ${power}"

done
