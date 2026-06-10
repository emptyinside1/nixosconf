{ config, pkgs, ... }:

{
  # === Hyprland Configuration ===
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  
  # Hyprlock needs PAM access
  security.pam.services.hyprlock = {};

  # Portals for screen sharing and file picking
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-wlr ];
    config.common.default = "*";
  };
}
