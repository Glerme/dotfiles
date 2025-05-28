# Glerme's Dotfiles

This repository contains my personal configuration files for a Wayland-based environment, including:

- **Compositor**: Hyprland
- **Status Bar**: Waybar
- **Application Launcher**: Wofi
- **Terminal Emulator**: Kitty

These configurations are managed and applied using [chezmoi](https://www.chezmoi.io/), facilitating synchronization and installation across multiple machines.

## Usage

### Prerequisites

- [chezmoi](https://www.chezmoi.io/) installed
- SSH key configured for GitHub access (recommended)

### Install dotfiles on a new machine

```bash
chezmoi init git@github.com:Glerme/dotfiles.git
chezmoi apply
```

### Editing Configurations

```bash
chezmoi edit ~/.config/hypr/hyprland.conf
```

After editing, apply the changes with:

```bash
chezmoi apply
```

### Update Dotfiles locally

To fetch updates:

```batch
chezmoi update
chezmoi apply
```

🔄 **Updating dotfiles in the repository**  
If you edited files directly in `~/.config` and want to reflect those changes in your dotfiles repository, run:

```bash
chezmoi add ~/.config/YOUR_FILE
chezmoi cd
git commit -m "Update YOUR_FILE"
git push
```
