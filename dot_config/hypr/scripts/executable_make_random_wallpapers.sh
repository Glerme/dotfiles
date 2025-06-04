#!/bin/bash

# Diretórios
SCRIPTS_DIR="$HOME/.config/hypr/scripts"
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Criação de pastas
mkdir -p "$SCRIPTS_DIR"
mkdir -p "$SYSTEMD_USER_DIR"
mkdir -p "$WALLPAPER_DIR"

# Script de wallpaper aleatório
cat > "$SCRIPTS_DIR/random_wallpaper.sh" << 'EOF'
#!/bin/bash
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
swww img "$WALLPAPER" --transition-type any --transition-duration 1
EOF

chmod +x "$SCRIPTS_DIR/random_wallpaper.sh"

# Service
cat > "$SYSTEMD_USER_DIR/wallpaper-random.service" << EOF
[Unit]
Description=Troca de wallpaper aleatória

[Service]
ExecStart=$SCRIPTS_DIR/random_wallpaper.sh
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
WantedBy=timers.target
EOF

# Ativação
systemctl --user daemon-reload
systemctl --user enable --now wallpaper-random.timer

echo "✅ Setup concluído! Timer ativado. Coloque imagens em: $WALLPAPER_DIR"
