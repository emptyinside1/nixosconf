{ inputs, config, pkgs, ... }:

{
  # Версия Home Manager (как stateVersion в NixOS)
  home.stateVersion = "25.11";
  
  imports = [
    ./shell.nix
    ./editor.nix
    ./git.nix
    ./pkgs.nix
    ./dotfiles.nix
    ./scripts.nix
    ./gtk.nix
    #./fastfetch.nix
    ./hyprland.nix
    ./opencode-log-cleaner.nix
    inputs.zen-browser.homeModules.twilight

  ];

  home.sessionPath = [
    "$HOME/.config/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];
}
