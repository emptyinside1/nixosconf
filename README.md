<div align="center">

```
    _   ___       ____  _____      ____  ____  ______
   / | / (_)  __ / __ \/ ___/     / __ \/ __ \/_  __/
  /  |/ / / |/_// / / /\__ \     / / / / / / / / /   
 / /|  / />  < / /_/ /___/ /    / /_/ / /_/ / / /    
/_/ |_/_/_/|_| \____//____/    /_____/\____/ /_/     
```

# Declarative NixOS Workstation — Niri & Hyprland Dual-Compositor Suite

[![NixOS Unstable](https://img.shields.io/badge/NixOS-Unstable%20%26%2025.11-5277C3?style=for-the-badge&logo=nixos&logoColor=white)](https://nixos.org)
[![Flakes](https://img.shields.io/badge/Nix-Flakes%20Enabled-7EB5E6?style=for-the-badge&logo=nixos&logoColor=white)](https://nixos.wiki/wiki/Flakes)
[![Niri](https://img.shields.io/badge/Compositor-Niri%20%2B%20Hyprland-CBA6F7?style=for-the-badge&logo=wayland&logoColor=1E1E2E)](https://github.com/YaLTeR/niri)
[![Nixvim](https://img.shields.io/badge/Editor-Nixvim%20IDE-A6E3A1?style=for-the-badge&logo=neovim&logoColor=1E1E2E)](https://github.com/nix-community/nixvim)
[![Catppuccin](https://img.shields.io/badge/Theme-Catppuccin%20Mocha-F5C2E7?style=for-the-badge)](https://github.com/catppuccin/catppuccin)
[![License: MIT](https://img.shields.io/badge/License-MIT-F9E2AF?style=for-the-badge)](https://opensource.org/licenses/MIT)

**A modular, hardware-decoupled, reproducible NixOS & Home Manager architecture engineered for scrollable-tiling productivity (Niri), dynamic eye-candy workflows (Hyprland), low-latency gaming, and zero-drift declarative IDE tooling.**

[Overview](#-overview) • [Component Stack](#-component-stack) • [Architecture](#-repository-architecture) • [Hardware & Drivers](#-hardware--driver-configuration) • [Installation](#-step-by-step-installation) • [Keybindings](#-keybindings-reference)

</div>

---

## ✨ Overview

This repository houses a full-stack **NixOS Flake** configuration built around strict modularity, reproducible developer environments, and seamless dual-compositor support:

- **Dual Wayland Compositors**: Switch effortlessly between **Niri** (infinite scrollable-tiling columns with zero-jank animations and multi-monitor MUX parity) and **Hyprland** (dynamic tiling with rich shader effects and Quickshell overview).
- **Declarative Neovim IDE (`Nixvim`)**: Preconfigured LSPs (`nixd`, `nil`, `lua_ls`, `pyright`, `ts_ls`, `rust_analyzer`), Treesitter grammar compilation, Telescope fuzzy finding, and `blink.cmp` completion—compiled directly into the Nix store.
- **Hardware-Decoupled Design**: Clean separation between system architecture (`modules/nixos/`), user environment (`modules/home/`), and host-specific hardware definitions (`hosts/desktop/`). Evaluates out-of-the-box using a fallback hardware template.
- **Hybrid GPU & Gaming Ready**: Pre-tuned for AMD iGPU + NVIDIA dGPU PRIME Offload, `amd_pstate=active`, CachyOS `ananicy-cpp` process rules, Feral `GameMode`, `MangoHud`, and `Sunshine` game streaming.
- **Custom Fuzzel TUI/GUI Menus**: Fast shell utilities in `dotfiles/bin/` for Bluetooth (`bluetuith`), Wi-Fi (`nmtui`), audio sinks (`pavucontrol`), power profiles (`powerprofilesctl`), monitor hot-toggling, clipboard history (`cliphist`), and wallpaper management (`awww` + `wallust`).

---

## 🧩 Component Stack

| Category | Component | Description |
| :--- | :--- | :--- |
| **OS & Package Manager** | **NixOS (`unstable` + `25.11`)** | Declarative system state with hybrid unstable/stable overlay support |
| **User Environment** | **Home Manager** | Declarative dotfiles, systemd user services, and user package sets |
| **Primary Compositor** | **Niri (`niri-flake`)** | Scrollable-tiling Wayland compositor with XWayland Satellite integration |
| **Secondary Compositor** | **Hyprland** | Dynamic tiling Wayland compositor with Wallust dynamic color generation |
| **Status Bar** | **Waybar** | Custom per-compositor status bars with interactive power/audio/network menus |
| **App Launcher & Menus** | **Fuzzel & Rofi** | Keyboard-driven launcher and custom dmenu scripts (`menu-*`) |
| **Notifications** | **Mako & SwayNC** | Lightweight notification daemon (Niri) & notification center (Hyprland) |
| **Terminal Emulators** | **Alacritty, Kitty, Ghostty, WezTerm** | GPU-accelerated terminals unified under **Catppuccin Mocha** & **Gruvbox** |
| **Shell & Multiplexer** | **Zsh + Starship + Zellij / Tmux** | Fast interactive shell with `zoxide`, `fzf`, `eza`, `bat`, and `pay-respects` |
| **Code Editor** | **Nixvim (Neovim)** | Fully declarative Neovim distribution with native LSP, Treesitter, and Lualine |
| **File Manager** | **Yazi & Thunar** | Blazing-fast terminal file manager with media previews + GTK file manager |
| **Audio Visualizer** | **Cava (Custom GLSL Shaders)** | Custom OpenGL fragment shaders (`orion_saturn_core`, `orion_circle_rotate`, etc.) |
| **Theme & Icons** | **Catppuccin Mocha + Papirus Dark** | Cohesive GTK3/GTK4, Qt5ct/Qt6ct, Kvantum, and Bibata Modern Ice cursor |
| **Browser** | **Zen Browser (`twilight`)** | Privacy-focused, vertical-tab browser integrated via flake input |

---

## 🗂️ Repository Architecture

```text
.
├── flake.nix                                 # Flake entrypoint, inputs, stable overlay & nixosConfigurations
├── flake.lock                                # Pinned reproducible dependency graph
├── hosts/
│   └── desktop/
│       ├── default.nix                       # Host system profile, locale, audio (PipeWire), display manager (Ly)
│       └── hardware-configuration.nix.example # Clean fallback hardware template (auto-used if hardware-configuration.nix is absent)
├── modules/
│   ├── nix-ld.nix                            # Dynamic linker compatibility for unpatched binaries
│   ├── nixos/
│   │   ├── gaming.nix                        # NVIDIA PRIME offload, Steam, GameMode, Ananicy-cpp, Sunshine
│   │   ├── hardware.nix                      # Power profiles daemon, udev AC/BAT auto-switching, optional Tuxedo drivers
│   │   ├── hyprland.nix                      # System-level Hyprland & XDG portal configuration
│   │   ├── networking.nix                    # NetworkManager, systemd-resolved, Tailscale, firewall & SSH config
│   │   ├── niri.nix                          # System-level Niri compositor, PAM/Polkit & keyring services
│   │   ├── nix-settings.nix                  # Experimental features, binary caches (Cachix), GC & store optimization
│   │   ├── packages.nix                      # Core system-wide CLI packages & fonts
│   │   └── zapret.nix                        # DPI bypass service module
│   └── home/
│       ├── default.nix                       # Home Manager entrypoint & module imports
│       ├── nixvim/                           # Modular declarative Neovim configuration (LSP, completion, UI, keymaps)
│       ├── niri.nix                          # Niri user packages, Yazi config & custom menu-* derivations
│       ├── hyprland.nix                      # Hyprland user packages & out-of-store config symlinks
│       ├── services.nix                      # Systemd user services (cliphist, battery-notifier, polkit, udiskie)
│       ├── rclone-sync.nix                   # Automated hourly Google Drive document backup timer
│       ├── gtk.nix                           # GTK, Qt, Kvantum & cursor theming
│       ├── pkgs.nix                          # GUI/CLI user applications & Syncthing declarative topology
│       ├── shell.nix                         # Zsh, Starship, aliases & environment variables
│       ├── git.nix                           # Declarative Git configuration & aliases
│       └── editor.nix                        # Fallback editor environment settings
├── pkgs/
│   └── youtube-music/
│       └── default.nix                       # Custom derivation packaging Pear YouTube Music desktop client
├── dotfiles/
│   ├── bin/                                  # Custom executable scripts (menu-*, shot-*, change-volume, etc.)
│   └── config/                               # Live-reloading configurations (niri, hyprland, waybar, cava, fuzzel, etc.)
├── docs/
│   ├── adr/                                  # Architecture Decision Records
│   └── cheatsheets/                          # Quick reference guides for Nixvim and Yazi
└── tests/
    ├── verify_public_showcase.sh             # Automated hygiene, decoupling & sanitization test suite
    ├── verify_nixvim.sh                      # Nixvim module evaluation tests
    └── verify_terminal_theme.sh              # Terminal & editor colorscheme verification
```

---

## ⚙️ Hardware & Driver Configuration

All machine-specific parameters are decoupled using `lib.mkDefault` so you can override them cleanly in `hosts/desktop/default.nix` or `hosts/desktop/hardware-configuration.nix`.

### 1. Hybrid GPU (AMD + NVIDIA PRIME Offload)
In `modules/nixos/gaming.nix`, hybrid graphics offload is configured with default PCI Bus IDs:
```nix
hardware.nvidia.prime = {
  offload = {
    enable = true;
    enableOffloadCmd = true; # Provides `nvidia-offload` wrapper
  };
  amdgpuBusId = lib.mkDefault "PCI:5:0:0";
  nvidiaBusId = lib.mkDefault "PCI:1:0:0";
};
```
**How to discover your GPU Bus IDs:**
```bash
nix-shell -p pciutils --run "lspci | grep -E 'VGA|3D'"
# Example output:
# 01:00.0 VGA compatible controller: NVIDIA Corporation AD107M [GeForce RTX 4060 Max-Q / Mobile] -> "PCI:1:0:0"
# 05:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Phoenix1             -> "PCI:5:0:0"
```
 Note: Convert hexadecimal values from `lspci` to decimal if needed (e.g., `0a:00.0` becomes `"PCI:10:0:0"`).

### 2. Clevo / Tongfang / Tuxedo Laptop Drivers
In `modules/nixos/hardware.nix`, vendor-specific chassis drivers (`tuxedo-drivers` and `tuxedo-rs` / `tailord` for keyboard backlight control) default to `false` for universal compatibility:
```nix
hardware.tuxedo-drivers.enable = lib.mkDefault false;
hardware.tuxedo-rs.enable = lib.mkDefault false;
hardware.tuxedo-rs.tailor-gui.enable = lib.mkDefault false;
```
To enable them on Clevo, Tongfang, Maibenben, or Tuxedo laptops, set them to `true` in your host configuration.

### 3. Gaming Optimizations
`modules/nixos/gaming.nix` enables a complete low-latency gaming stack out of the box:
- **CPU Governor**: `amd_pstate=active` kernel parameter with automatic AC/Battery profile switching via `power-profiles-daemon` udev rules.
- **Process Scheduler**: `services.ananicy` with `ananicy-rules-cachyos` for automatic real-time nice level prioritization.
- **Feral GameMode**: Automatic CPU governor and renice boosts on game launch with desktop notifications.
- **Controller Support**: `xpadneo`, `joycond`, `steam-hardware`, and `uinput` kernel modules preloaded.

---

## 🚀 Step-by-Step Installation

### 1. Clone the Repository
Clone the repository into `~/.nixos` (used by Home Manager out-of-store symlinks for instant dotfile live-reloading):
```bash
git clone https://github.com/<your-username>/nixos-config.git ~/.nixos
cd ~/.nixos
```

### 2. Generate Your Hardware Configuration
Generate a `hardware-configuration.nix` matching your machine's disk UUIDs, filesystems, and kernel modules:
```bash
nixos-generate-config --show-hardware-config > hosts/desktop/hardware-configuration.nix
```
*(Note: `hosts/desktop/hardware-configuration.nix` is git-ignored to prevent leaking personal partition UUIDs. If omitted during CI or dry-run evaluation, `hosts/desktop/default.nix` automatically falls back to `hosts/desktop/hardware-configuration.nix.example`.)*

### 3. Customize Username & Git Identity
1. Update the username in `flake.nix` (`home-manager.users.<username>`) and `hosts/desktop/default.nix` (`users.users.<username>`).
2. Set your Git author name and email in `modules/home/git.nix`.
3. Adjust monitor outputs in `dotfiles/config/niri/config.kdl` and `dotfiles/config/hypr/monitors.conf`.

### 4. Validate & Build the Flake
Evaluate the system derivation to verify syntax and module integrity before switching:
```bash
# Verify configuration evaluation
nix eval .#nixosConfigurations.nixos.config.system.build.toplevel.drvPath

# Run the repository verification suite
nix develop --command bash tests/verify_public_showcase.sh

# Build and activate the system configuration
sudo nixos-rebuild switch --flake .#nixos
```

---

## ⌨️ Keybindings Reference

Press **`Mod + F1`** at any time inside Niri to open the interactive Fuzzel keybindings cheatsheet (`menu-keybinds`).

| Shortcut | Action | Command / Dispatcher |
| :--- | :--- | :--- |
| **`Mod + Return`** | Launch Terminal | `alacritty` |
| **`Mod + D`** | Application Launcher | `fuzzel` |
| **`Mod + E`** | Terminal File Manager | `alacritty -e yazi` |
| **`Mod + B`** | Default Web Browser | `xdg-open https://` |
| **`Mod + `` ` `` (Grave)** | Toggle Dropdown Terminal | `dropdown-terminal` |
| **`Mod + Space`** | Switch Keyboard Layout (EN/RU) | `notify-layout` |
| **`Mod + Q`** | Close Focused Window | `close-window` |
| **`Mod + Shift + Q`** | Force Kill Active Process | `kill-active-process` |
| **`Mod + H / J / K / L`** | Focus Column / Window (Left/Down/Up/Right) | `focus-column-*` / `focus-window-*` |
| **`Mod + Shift + H / J / K / L`** | Move Column / Window | `move-column-*` / `move-window-*` |
| **`Mod + Alt + H / L`** | Focus Monitor Left / Right | `focus-monitor-left` / `right` |
| **`Mod + Alt + Shift + H / L`** | Move Column to Monitor Left / Right | `move-column-to-monitor-left` / `right` |
| **`Mod + R`** | Cycle Column Width Presets (1/3, 1/2, 2/3, 100%) | `switch-preset-column-width` |
| **`Mod + F` / `Mod + Shift + F`** | Maximize Column / Fullscreen Window | `maximize-column` / `fullscreen-window` |
| **`Mod + Shift + Space`** | Toggle Floating Mode | `toggle-window-floating` |
| **`Mod + Tab`** | Switch Focus Between Floating & Tiling | `switch-focus-between-floating-and-tiling` |
| **`Mod + [ / ]`** | Consume or Expel Window Left / Right | `consume-or-expel-window-*` |
| **`Mod + 1..9`** | Focus Workspace 1–9 | `focus-workspace 1..9` |
| **`Mod + Shift + 1..9`** | Move Column to Workspace 1–9 | `move-column-to-workspace 1..9` |
| **`Mod + P`** | Power Profile Selector (Performance/Balanced/Saver) | `menu-power-profile` |
| **`Mod + Shift + P`** | Monitor Output Toggle Menu | `menu-monitors` |
| **`Mod + Shift + B`** | Bluetooth TUI Manager | `bluetuith` |
| **`Mod + Alt + V`** | Clipboard History Manager | `menu-clipboard` |
| **`Mod + W`** | Wallpaper Selector (`awww`) | `menu-wallpaper` |
| **`Mod + C`** | Quick Config Editor Menu | `menu-configs` |
| **`Mod + S`** | Web Search Prompt | `menu-websearch` |
| **`Mod + Ctrl + S`** | Open Window Switcher Menu | `menu-windows` |
| **`Print` / `Mod + Shift + S`** | Region Screenshot (Grim + Slurp + Swappy) | `shot-region` |
| **`Alt + Print`** | Active Window Screenshot | `shot-active` |
| **`Mod + Print`** | Fullscreen Screenshot | `shot-full` |
| **`Mod + Escape` / `Ctrl + Alt + P`** | System Power Menu | `menu-power` |

---

## 🧪 Verification & Testing

This repository includes automated verification scripts under `tests/` to guarantee hygiene, secret sanitization, and flake evaluation integrity:

```bash
# Run the public showcase verification suite
nix develop --command bash tests/verify_public_showcase.sh
```
