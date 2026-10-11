{ config, pkgs, inputs, ... }:

{
  # === Niri Configuration via niri-flake ===
  imports = [
    inputs.niri.nixosModules.niri
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  # Security / PAM configuration for swaylock screen locking
  security.pam.services.swaylock = {};

  # Portals for Niri (GNOME & GTK portals recommended for standard wayland/niri)
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # System/Core Packages for Niri desktop environment
  environment.systemPackages = with pkgs; [
    alacritty
    fuzzel
    waybar
    swaylock
    mako
    mpvpaper
    wbg
    awww
    grim
    slurp
    wl-clipboard
    cliphist
    yazi
    zellij
    btop
    bat
    eza
    xwayland-satellite
    brightnessctl
    playerctl
    power-profiles-daemon
  ];
}
