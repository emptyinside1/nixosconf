{ inputs, config, pkgs, pkgs-stable, ... }:

{
  # Версия Home Manager (как stateVersion в NixOS)
  home.stateVersion = "25.11";
  
  imports = [
    ./home/shell.nix
    ./home/editor.nix
    ./home/git.nix
    ./home/pkgs.nix
    ./home/dotfiles.nix
    ./home/scripts.nix
    ./home/gtk.nix
    #./home/fastfetch.nix
    ./home/hyprland.nix
    inputs.zen-browser.homeModules.twilight

  ];

  home.sessionPath = [
    "$HOME/.config/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];

  systemd.user.services.sunshine = {
    Unit = {
      Description = "Sunshine Game Streamer";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.sunshine}/bin/sunshine";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
