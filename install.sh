#!/bin/bash
set -e

# Pacotes dos repositórios oficiais
PACMAN_PACKAGES=(
  base-devel
  brightnessctl
  blueman
  chezmoi
  cliphist
  curl
  docker
  docker-compose
  dolphin
  dunst
  eza
  fastfetch
  firefox
  flatpak
  fzf
  git
  gtk4
  htop
  hyprland
  hyprpicker
  hyprshot
  jq
  kitty
  neovim
  network-manager-applet
  networkmanager
  nwg-displays
  nwg-dock-hyprland
  nwg-look
  noto-fonts-cjk
  noto-fonts-emoji
  noto-fonts-extra
  pavucontrol
  pipewire
  pipewire-alsa
  pipewire-jack
  pipewire-pulse
  polkit-gnome
  ripgrep
  scrcpy
  starship
  swww
  ttf-fira-code
  ttf-nerd-fonts-symbols
  vim
  waybar
  wget
  wofi
  xclip
  xdg-utils
  zsh
  zsh-completions
)

# Pacotes do AUR
AUR_PACKAGES=(
  bibata-cursor-theme-bin
  google-chrome
  hyprshade
  rofi-wayland
  swaync
  waypaper
)

# Instala pacotes oficiais com pacman
echo "Instalando pacotes dos repositórios oficiais..."
sudo pacman -Sy --needed --noconfirm "${PACMAN_PACKAGES[@]}"

# Verifica se yay está instalado
if ! command -v yay &>/dev/null; then
  echo "yay não encontrado. Instalando yay..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
fi

# Instala pacotes do AUR
echo "Instalando pacotes do AUR..."
yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"

# Configurações do chezmoi
if ! command -v chezmoi &>/dev/null; then
  echo "chezmoi não encontrado. Abortando."
  exit 1
fi

if [ ! -d "$HOME/.local/share/chezmoi" ]; then
  echo "Inicializando chezmoi com seu repositório..."
  chezmoi init git@github.com:Glerme/dotfiles.git
else
  echo "chezmoi já está inicializado."
fi

echo "Aplicando configurações do chezmoi..."
chezmoi apply

# Pós-instalação: habilita e inicia o docker
if command -v systemctl &>/dev/null; then
  echo "Habilitando e iniciando o serviço do Docker..."
  sudo systemctl enable docker.service
  sudo systemctl start docker.service
fi

# Pós-instalação: altera o shell padrão para zsh
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Alterando o shell padrão para zsh..."
  chsh -s "$(which zsh)"
fi
