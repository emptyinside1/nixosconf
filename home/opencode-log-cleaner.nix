{ config, lib, pkgs, ... }:

{
  systemd.user.services.opencode-log-cleaner = {
    Unit = {
      Description = "Clean OpenCode logs if they exceed 1.5GB";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'if [ -d %h/.local/share/opencode/log ]; then SIZE=$(du -sm %h/.local/share/opencode/log | cut -f1); if [ \"$SIZE\" -ge 1536 ]; then rm -rf %h/.local/share/opencode/log; echo \"Cleaned opencode logs\"; fi; fi'";
    };
  };

  systemd.user.timers.opencode-log-cleaner = {
    Unit = {
      Description = "Timer to clean OpenCode logs periodically";
    };
    Timer = {
      OnBootSec = "5m";
      OnUnitActiveSec = "30m";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
