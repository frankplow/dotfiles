#!/usr/bin/env bash

#if xdo id -a "$PANEL_WM_NAME" > /dev/null ; then
#        printf "%s\n" "The panel is already running." >&2
#            exit 1
#fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

WIDTH=$(xrandr | tr , $'\n' | grep current | cut -d' ' -f3)
HEIGHT=$(xrandr | tr , $'\n' | grep current | cut -d' ' -f5)
widgetdir="${0%/*}/bar"
PANEL_FIFO="/tmp/lemon_fifo"

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

# launch the bar
cat $PANEL_FIFO | $widgetdir/reader.sh | lemonbar\
 -g $(($WIDTH - $THEME_WINDOW_GAP - $THEME_WINDOW_GAP - $THEME_BORDER_WIDTH - $THEME_BORDER_WIDTH))\
x$(($THEME_BAR_HEIGHT - $THEME_BORDER_WIDTH))\
+$THEME_WINDOW_GAP+$THEME_WINDOW_GAP\
 -f "$THEME_FONT_TEXT:size=$THEME_FONT_SIZE"\
 -f "$THEME_FONT_SYMBOLS:size=$THEME_FONT_SIZE"\
 -f "$THEME_FONT_UNICODE:size=$THEME_FONT_SIZE"\
 -F "#$THEME_BAR_FOREGROUND" -B "#$THEME_BAR_BACKGROUND"\
 -r $THEME_BORDER_WIDTH -R "#$THEME_BAR_BORDER"\
 -a 16 | bash &

# launch widgets
$widgetdir/arch.sh > "$PANEL_FIFO" &
$widgetdir/bspwm.sh > "$PANEL_FIFO" &
$widgetdir/clock.sh > "$PANEL_FIFO" &
$widgetdir/date.sh > "$PANEL_FIFO" &
$widgetdir/power.sh > "$PANEL_FIFO" &
$widgetdir/spotify.sh > "$PANEL_FIFO" &
$widgetdir/volume_alsa.sh > "$PANEL_FIFO" &
#$widgetdir/volume_pulse.sh > "$PANEL_FIFO" &
$widgetdir/network.sh > "$PANEL_FIFO" &
$widgetdir/battery.sh > "$PANEL_FIFO" &

# ensure bar goes underneath fullscreen windows
sleep 1
xdo above -t "$(xdo id -N Bspwm -n root | sort | head -n 1)" $(xdo id -a bar)

wait

