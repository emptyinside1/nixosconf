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

  # Polkit GNOME package
  environment.systemPackages = [ pkgs.polkit_gnome ];

  # Polkit and login1 rules
  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (
          action.id.indexOf("org.freedesktop.login1.power-off") === 0 ||
          action.id.indexOf("org.freedesktop.login1.reboot") === 0 ||
          action.id.indexOf("org.freedesktop.login1.suspend") === 0 ||
          action.id.indexOf("org.freedesktop.login1.hibernate") === 0
        ) {
          if (subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
        }
      });
    '';
  };

  # Polkit GNOME authentication agent systemd user service
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
