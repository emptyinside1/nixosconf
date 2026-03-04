# NixOS Configuration (Flakes & Home Manager)

A personalized NixOS configuration repository focused on building a modular, Hyprland-based desktop environment for the user `daniil`. This configuration is heavily influenced by "JaKooLit's" Hyprland dots and leverages Nix Flakes and Home Manager for declarative management.

## Project Overview

- **Core OS**: NixOS (Unstable channel for most packages, Stable 25.11 for specific needs).
- **WM/DE**: Hyprland (primary) with Cinnamon (fallback/desktop manager).
- **Core Toolset**:
    - **Bar**: Waybar
    - **Launcher**: Rofi
    - **Notifications**: SwayNotificationCenter (SwayNC)
    - **Terminal**: Kitty
    - **Wallpapers/Theming**: `swww`, `wallust`, `nwg-look`
    - **File Manager**: Thunar
- **Package Management**: Managed via `flake.nix`, `sys-pkgs.nix`, and `home/pkgs.nix`.
- **Key Features**:
    - **Gaming**: Optimized via `gaming-optimization.nix`.
    - **Networking**: Integration of `zapret`, `amnezia-vpn`, and `syncthing`.
    - **Browser**: Custom `zen-browser` flake integration.
    - **Shell**: Zsh with `starship` and `pay-respects`.

## Project Structure

```text
.
├── flake.nix                # Entry point for the Nix flake and inputs
├── configuration.nix        # System-level NixOS configuration
├── home.nix                 # Entry point for Home Manager (user: daniil)
├── hardware-configuration.nix # Auto-generated hardware settings
├── sys-pkgs.nix             # System-wide packages and services
├── gaming-optimization.nix  # Gaming-specific tweaks and tools
├── sync.sh                  # Utility script to push changes to Git
├── home/                    # Modular Home Manager configurations
│   ├── shell.nix            # Zsh, starship, aliases
│   ├── editor.nix           # Neovim configuration via Home Manager
│   ├── git.nix              # Git configuration
│   ├── pkgs.nix             # User-level packages (Telegram, Steam, etc.)
│   ├── hyprland.nix         # Hyprland core tools and dotfile symlinks
│   └── dotfiles.nix         # Additional dotfile management (examples)
├── dotfiles/                # Source configuration files
│   └── config/              # Active dotfiles symlinked to ~/.config/
└── modules/                 # Custom shared Nix modules
```

## Key Workflows

### Apply Configuration
To apply the current configuration to the system:
```bash
sudo nixos-rebuild switch --flake .#nixos
```

### Update Flake
To update flake inputs (e.g., get latest Hyprland or nixpkgs):
```bash
nix flake update
```

### Git Sync
To commit and push changes to your repository:
```bash
./sync.sh
```

## Development Conventions

- **In-Place Dotfile Editing**: This project uses `mkOutOfStoreSymlink` (defined in `home/hyprland.nix`) to symlink files from `~/.nixos/dotfiles/config/` directly to `~/.config/`. This allows you to edit configuration files (like Hyprland, Waybar, or Kitty) and have changes take effect immediately (or after a reload) without a full `nixos-rebuild`.
- **Modularization**: Keep system-level changes in `configuration.nix` and user-level changes in `home/`.
- **AppImage Compatibility**: `nix-ld` is extensively configured in `sys-pkgs.nix` to support Electron and other complex AppImages.
- **Dual Package Channels**: Use `pkgs-stable` for stability and `pkgs` for latest features.
