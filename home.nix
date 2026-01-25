{ inputs, config, pkgs, pkgs-stable, ... }:

{
  # Версия Home Manager (как stateVersion в NixOS)
  home.stateVersion = "25.11";
  
  imports = [
    inputs.zen-browser.homeModules.twilight
    ./home/shell.nix
    ./home/editor.nix
    ./home/git.nix
    ./home/pkgs.nix
    ./home/dotfiles.nix
    ./home/scripts.nix
  ];

  home.sessionPath = [
    "$HOME/.config/bin"
    "$HOME/.config/bin"
  ];
}
