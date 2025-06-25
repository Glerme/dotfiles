#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Garante que existe
[ ! -d "$WALLPAPER_DIR" ] && {
  notify-send "❌ Pasta não encontrada" "$WALLPAPER_DIR"
  exit 1
}

# Lista arquivos
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.jpeg' \))

[ ${#WALLPAPERS[@]} -eq 0 ] && {
  notify-send "⚠️ Nenhum wallpaper encontrado" "Verifique $WALLPAPER_DIR"
  exit 1
}

# Exibe via rofi (ou wofi/tofi se quiser)
CHOSEN=$(printf '%s\n' "${WALLPAPERS[@]}" | rofi -dmenu -p "Escolha o wallpaper:" -theme ~/.config/rofi/themes/wallpapers.rasi)

# Se cancelar
[ -z "$CHOSEN" ] && exit 0

# Aplica
swww img "$CHOSEN" --transition-type grow --transition-duration 0.7

# Salva como último
echo "$CHOSEN" > ~/.cache/last_wallpaper.txt
echo "$(date '+%F %T') - $CHOSEN" >> ~/.cache/wallpaper_history.log
