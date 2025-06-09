#!/bin/bash

# Diretórios
SCRIPTS_DIR="$HOME/.config/hypr/scripts"
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Criação de pastas
mkdir -p "$SCRIPTS_DIR" "$SYSTEMD_USER_DIR" "$WALLPAPER_DIR"

# Script de wallpaper aleatório
cat > "$SCRIPTS_DIR/random_wallpaper.sh" << 'EOF'
#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Espera pelo socket do swww-daemon (se não estiver pronto ainda)
for i in {1..10}; do
  [ -S "$XDG_RUNTIME_DIR/swww.sock" ] && break
  sleep 0.1
done

if [ ! -S "$XDG_RUNTIME_DIR/swww.sock" ]; then
  notify-send "❌ Erro: swww não está rodando"
  exit 1
fi

WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.jpeg' \) | shuf -n 1)

[ -z "$WALLPAPER" ] && {
  notify-send "⚠️ Nenhum wallpaper encontrado em $WALLPAPER_DIR"
  exit 1
}

swww img "$WALLPAPER" --transition-type any --transition-duration 1
EOF

chmod +x "$SCRIPTS_DIR/random_wallpaper.sh"

# Service
cat > "$SYSTEMD_USER_DIR/wallpaper-random.service" << EOF
[Unit]
Description=Troca de wallpaper aleatória
After=graphical-session.target

[Service]
ExecStart=$SCRIPTS_DIR/random_wallpaper.sh
Type=oneshot
EOF

# Timer
cat > "$SYSTEMD_USER_DIR/wallpaper-random.timer" << EOF
[Unit]
Description=Timer para wallpaper aleatório a cada 10 minutos

[Timer]
OnBootSec=1min
OnUnitActiveSec=10min
Persistent=true

[Install]
WantedBy=default.target
EOF

# Ativação
systemctl --user daemon-reload
systemctl --user enable --now wallpaper-random.timer

echo "✅ Setup concluído! Timer ativado. Coloque imagens em: $WALLPAPER_DIR"
