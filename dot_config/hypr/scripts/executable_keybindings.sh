#!/bin/bash
# Hyprland keybindings viewer with pretty output

config_file="$HOME/.config/hypr/conf/keybinding.conf"

if [ ! -f "$config_file" ]; then
  echo "Arquivo de configuração não encontrado: $config_file"
  exit 1
fi

# Cabeçalho com separadores
header="Atalho               │ Comando"
divider="──────────────────────┼────────────────────────────────────"

# Extrair e formatar os keybinds
keybinds=$(awk '
  BEGIN { OFS = "" }
  /^\s*bind/ {
    gsub(/\$mainMod/, "SUPER", $0)
    sub(/^bind\s*=\s*/, "")
    split($0, arr, ",")
    key=arr[1]
    gsub(/^[ \t]+|[ \t]+$/, "", key)
    cmd=arr[3]
    for (i=4; i<=length(arr); i++) cmd=cmd","arr[i]
    gsub(/^[ \t]+|[ \t]+$/, "", cmd)
    printf("%-20s │ %s\n", key, cmd)
  }
' "$config_file")

if [ -z "$keybinds" ]; then
  notify-send "Keybinds" "Nenhum atalho encontrado em $config_file"
  exit 0
fi

# Concatenar tudo e exibir no rofi
{
  echo "$header"
  echo "$divider"
  echo "$keybinds"
} | rofi -dmenu -i -p "Keybinds" -config ~/.config/rofi/config-compact.rasi
