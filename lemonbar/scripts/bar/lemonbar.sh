#!/bin/env bash

widgetdir="$HOME/scripts/bar"
PANEL_FIFO="/tmp/lemon_fifo"

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

$widgetdir/arch.sh > "$PANEL_FIFO" &
$widgetdir/bspwm.sh > "$PANEL_FIFO" &
$widgetdir/clock.sh > "$PANEL_FIFO" &
$widgetdir/date.sh > "$PANEL_FIFO" &
$widgetdir/power.sh > "$PANEL_FIFO" &
$widgetdir/spotify.sh > "$PANEL_FIFO" &
$widgetdir/volume_alsa.sh > "$PANEL_FIFO" &
#$widgetdir/volume_pulse.sh > "$PANEL_FIFO" &

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

done < <(cat $PANEL_FIFO)
