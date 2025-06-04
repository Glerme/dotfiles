# Glerme's Dotfiles

This repository contains my personal configuration files for a Wayland-based environment, including:

- **Compositor**: Hyprland
- **Status Bar**: Waybar
- **Application Launcher**: Rofi
- **Terminal Emulator**: Kitty

These configurations are managed and applied using [chezmoi](https://www.chezmoi.io/), facilitating synchronization and installation across multiple machines.

---

## Usage

### Prerequisites

- Arch-based Linux distribution
- SSH key configured for GitHub access (recommended)

---

### Install everything on a new machine

Clone the repository and run the setup script to install packages and apply all configurations automatically:

```bash
git clone git@github.com:Glerme/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

> This will:
>
> - Install all required official and AUR packages
> - Install `yay` (AUR helper) if not present
> - Initialize `chezmoi` with this repository (if needed)
> - Apply dotfiles with `chezmoi apply`
> - Enable and start Docker
> - Change the default shell to `zsh`

---

### Editing Configurations

Use chezmoi to safely edit and manage your dotfiles:

```bash
chezmoi cd
chezmoi edit ~/.config/hypr/hyprland.conf
```

Or open files directly:

```bash
chezmoi cd
nvim dot_config/PATH_TO_FILE
```

or

```bash
chezmoi cd
code dot_config/PATH_TO_FILE
```

After editing, apply the changes with:

```bash
chezmoi apply
```

---

### Updating Dotfiles locally

Fetch updates from the remote repository and apply them:

```bash
chezmoi update
chezmoi apply
```

---

### Sync local changes back to the repository

If you edit files directly in `~/.config` and want to track those changes in your dotfiles repo:

```bash
chezmoi add ~/.config/YOUR_FILE
chezmoi cd
git commit -m "Update YOUR_FILE"
git push
```
