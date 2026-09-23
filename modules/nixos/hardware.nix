{ config, pkgs, ... }:

{
  hardware.tuxedo-drivers.enable = true;

  # tailord корректно управляет подсветкой через /dev/tuxedo_io
  hardware.tuxedo-rs.enable = true;
  hardware.tuxedo-rs.tailor-gui.enable = true;

  services.power-profiles-daemon.enable = true;
  boot.kernelParams = [ "processor.max_cstate=5" "idle=nomwait" ];

  # Асинхронное переключение профилей питания через udev + systemd
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ATTR{type}=="Mains", TAG+="systemd", ENV{SYSTEMD_WANTS}+="power-profile-switch.service"
  '';

  systemd.services.power-profile-switch = {
    description = "Synchronize power-profiles-daemon profile based on AC/BAT state";
    wants = [ "power-profiles-daemon.service" ];
    after = [ "power-profiles-daemon.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "power-profile-switch-script" ''
        # Ожидаем, пока power-profiles-daemon опросит D-Bus и заполнит профили (до 5 сек)
        for i in $(seq 1 10); do
          if ${pkgs.power-profiles-daemon}/bin/powerprofilesctl list 2>/dev/null | grep -q "balanced:"; then
            break
          fi
          sleep 0.5
        done

        # Проверяем статус подключения к сети
        is_ac=0
        for ac in /sys/class/power_supply/AC*/online /sys/class/power_supply/A*/online; do
          if [ -f "$ac" ] && [ "$(cat "$ac" 2>/dev/null)" = "1" ]; then
            is_ac=1
            break
          fi
        done

        if [ "$is_ac" -eq 1 ]; then
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance 2>/dev/null || ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced
        else
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver 2>/dev/null || ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced
        fi
      '';
    };
  };
}
