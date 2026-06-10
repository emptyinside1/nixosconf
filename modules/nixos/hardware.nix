{ config, pkgs, ... }:

{
  # 1. Оставляем драйвер (ядро должно видеть устройство)
  hardware.tuxedo-drivers.enable = true;

  # 2. ВЫКЛЮЧАЕМ tuxedo-rs (именно он перехватывал управление и мешал)
  hardware.tuxedo-rs.enable = false;

  # 3. Создаем свою службу для установки белого цвета
  systemd.services.keyboard-rgb-setup = {
    description = "Set keyboard backlight to white";
    
    # Запускаем, как только устройство подсветки появится в системе
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];

    script = ''
      # Ждем секунду, чтобы драйвер точно проинициализировался
      sleep 1
      
      # Устанавливаем БЕЛЫЙ цвет (Максимум по всем трем каналам RGB)
      if [ -f /sys/class/leds/rgb:kbd_backlight/multi_intensity ]; then
        echo "255 255 255" > /sys/class/leds/rgb:kbd_backlight/multi_intensity
        
        # Устанавливаем яркость на максимум (у тебя это 4)
        echo 4 > /sys/class/leds/rgb:kbd_backlight/brightness
      fi
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
