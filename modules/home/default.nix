{ inputs, config, pkgs, ... }:

{
  # Версия Home Manager (как stateVersion в NixOS)
  home.stateVersion = "25.11";
  
  imports = [
    ./shell.nix
    ./editor.nix
    ./nixvim
    ./git.nix
    ./pkgs.nix
    ./dotfiles.nix
    ./scripts.nix
    ./gtk.nix
    #./fastfetch.nix
    ./hyprland.nix
    ./niri.nix
    ./opencode-log-cleaner.nix
    ./rclone-sync.nix
    inputs.zen-browser.homeModules.twilight
    inputs.nixvim.homeModules.nixvim
  ];

  home.sessionPath = [
    "$HOME/.config/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];
}
