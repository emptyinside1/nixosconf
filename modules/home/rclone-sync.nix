{ config, lib, pkgs, ... }:

{
  systemd.user.services.rclone-sync = {
    Unit = {
      Description = "Sync Documents to Google Drive using rclone";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.rclone}/bin/rclone sync ${config.home.homeDirectory}/Documents gdrive:Documents_Backup --log-file=${config.home.homeDirectory}/Documents/rclone_sync.log --log-level INFO";
    };
  };

  systemd.user.timers.rclone-sync = {
    Unit = {
      Description = "Run rclone sync every hour";
    };

    Timer = {
      OnCalendar = "hourly";
      Persistent = true;
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}