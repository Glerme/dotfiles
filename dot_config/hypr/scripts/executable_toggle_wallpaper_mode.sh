#!/bin/bash

STATE_FILE="$HOME/.config/hypr/scripts/.wallpaper_mode"

[ ! -f "$STATE_FILE" ] && echo "fixed" > "$STATE_FILE"

MODE=$(cat "$STATE_FILE")

if [ "$MODE" = "random" ]; then
  echo "fixed" > "$STATE_FILE"
  notify-send "Wallpaper Mode" "Changed to: Fixed"
else
  echo "random" > "$STATE_FILE"
  notify-send "Wallpaper Mode" "Changed to: Random"
fi
