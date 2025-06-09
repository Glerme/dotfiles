#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_FILE="$HOME/.cache/wallpapers_list.txt"
LAST_FILE="$HOME/.cache/last_wallpaper.txt"
TRANSITION="any"
DURATION="0.5"

# Garante que o daemon esteja ativo
if ! pgrep -x swww-daemon >/dev/null 2>&1; then
  swww-daemon &
fi

# Espera o socket aparecer (até 1s)
for i in {1..10}; do
  [ -S "$XDG_RUNTIME_DIR/swww.sock" ] && break
  sleep 0.1
done


# Garante que diretórios de cache existam
mkdir -p "$(dirname "$CACHE_FILE")"

# Atualiza cache se necessário
if [ ! -f "$CACHE_FILE" ] || [ "$(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -newer "$CACHE_FILE" | wc -l)" -gt 0 ]; then
  find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) > "$CACHE_FILE"
fi

# Lê wallpapers da lista
IFS=$'\n' read -d '' -r -a WALLPAPERS < "$CACHE_FILE"
unset IFS

# Verifica se há wallpapers
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
  notify-send "⚠️ Nenhum wallpaper encontrado" "Verifique a pasta: $WALLPAPER_DIR"
  exit 1
fi

# Lê o último usado (se existir)
LAST_WP=""
[ -f "$LAST_FILE" ] && LAST_WP=$(<"$LAST_FILE")

# Escolhe um novo diferente do último
RANDOM_WP=""
if [ ${#WALLPAPERS[@]} -eq 1 ]; then
  RANDOM_WP="${WALLPAPERS[0]}"
else
  ATTEMPTS=0
  MAX_ATTEMPTS=10
  while [ $ATTEMPTS -lt $MAX_ATTEMPTS ]; do
    RANDOM_WP=$(shuf -n 1 "$CACHE_FILE")
    [ "$RANDOM_WP" != "$LAST_WP" ] && break
    ((ATTEMPTS++))
  done
fi

# Salva o novo wallpaper como último usado
echo "$RANDOM_WP" > "$LAST_FILE"

# Aplica o wallpaper
swww img "$RANDOM_WP" --transition-type "$TRANSITION" --transition-duration "$DURATION"

# Notifica
notify-send -i "$RANDOM_WP" "Wallpaper trocado" "$(basename "$RANDOM_WP")"
