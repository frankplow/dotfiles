#!/usr/bin/env bash

dbus-monitor --profile "interface='org.freedesktop.DBus.Properties',member='PropertiesChanged'" |
    while read -r line; do
        echo $line | grep PropertiesChanged > /dev/null &&
            if pgrep -x "spotify" > /dev/null; then
                NAME=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | grep -iC1 title | tail -n1 | cut -d'"' -f2)
                ARTIST=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | grep -iC2 :artist | tail -n1 | cut -d'"' -f2)
                STATUS=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | grep string | cut -d'"' -f2 | tr -d '[:space:]')
                RET="F\u$THEME_SYMBOL_MUSIC $ARTIST - $NAME %{A:dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause:}"
                if [ "$STATUS" == "Paused" ]; then
                    RET="$RET\u$THEME_SYMBOL_PLAY%{A}"
                else
                    RET="$RET\u$THEME_SYMBOL_PAUSE%{A}"
                fi
                echo -e $RET
            fi
    done
