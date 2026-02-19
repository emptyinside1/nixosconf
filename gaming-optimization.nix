{ config, lib, pkgs, ... }:

{
  # ---------------------------------------------------------------------
  # 1. Hardware & Driver Optimization
  # ---------------------------------------------------------------------

  # Включаем поддержку графики (ранее hardware.opengl в stable версиях)
  hardware.graphics = {
    enable = true;
    # Поддержка 32-битных библиотек (критично для Steam и Wine)
    enable32Bit = true;
  };

  # Загрузка драйверов NVIDIA
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  hardware.nvidia = {
    # Modesetting обязателен для Wayland (Hyprland) и корректной работы драйвера
    modesetting.enable = true;

    # Использовать проприетарные драйверы (стабильнее для игр на данный момент)
    open = false;

    # Включаем управление питанием (важно для ноутбуков)
    powerManagement.enable = true;
    
    # Finegrained power management: переводит GPU в режим D3 (полное выключение),
    # когда он не используется. Критично для батареи на гибридных ноутбуках.
    powerManagement.finegrained = true;

    # Выбор версии драйвера. Production обычно самый стабильный.
    # Для RTX 4060 можно пробовать и beta, если нужны последние фичи DLSS.
    package = config.boot.kernelPackages.nvidiaPackages.production;

    # Настройка PRIME (Гибридная графика)
    prime = {
      # Режим Offload: по умолчанию работает AMD, NVIDIA включается только по команде.
      offload = {
        enable = true;
        enableOffloadCmd = true; # Создает скрипт nvidia-offload
      };
      
      # ВНИМАНИЕ: Замени эти значения на свои! 
      # Узнать их можно командой: lspci | grep -E 'VGA|3D'
      # Формат: BusID "PCI:1:0:0" (пример)
      amdgpuBusId = "PCI:5:0:0"; # Впиши ID встройки AMD
      nvidiaBusId = "PCI:1:0:0"; # Впиши ID дискретки NVIDIA
    };
  };

  # ---------------------------------------------------------------------
  # 2. Kernel & CPU Scheduling (Anti-Lag)
  # ---------------------------------------------------------------------
  
  boot.kernelParams = [
    # Включаем современный драйвер частот для AMD Ryzen (Zen 2 и новее)
    # Обеспечивает более быструю реакцию на изменение нагрузки.
    "amd_pstate=active" 
  ];

  # Ananicy-cpp: демонический ренайсер (авто-приоритет процессов)
  # Снижает лаги интерфейса, повышая приоритет активного окна и Xorg/Wayland.
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos; # Оптимизированные правила (как в CachyOS)
  };

  # ---------------------------------------------------------------------
  # 3. GameMode & Software
  # ---------------------------------------------------------------------

  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
      };
      # Скрипты для выполнения при запуске игры
      # Можно добавить отключение эффектов композитора Hyprland, если нужно
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimization Enabled'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimization Disabled'";
      };
    };
  };

  # Steam оптимизации
  programs.steam = {
    enable = true;
    gamescopeSession.enable = false; # Поддержка Gamescope (полезно для Steam Deck UI / Hyprland)
    protontricks.enable = true;
  };
  
  # Окружение для корректной работы VAAPI и CUDA
  environment.sessionVariables = {
    # Убираем возможные фризы в Hyprland на NVIDIA
    # LIBVA_DRIVER_NAME = "nvidia"; # Раскомментировать, если видео не играет в браузере
    # XDG_SESSION_TYPE = "wayland";
    # GBM_BACKEND = "nvidia-drm";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia"; 
    # ^ Эти переменные лучше задавать в конфиге Hyprland или враппере,
    # так как глобально они могут сломать софт, работающий на AMD встройке.
  };
  
  # Утилиты для мониторинга
  environment.systemPackages = with pkgs; [
    mangohud      # FPS мониторинг
    protonup-qt   # Управление версиями Proton (GE-Proton)
    lutris        # Лаунчер для сторонних игр
    wine
  ];
  
  # Поддержка джойстика
  hardware.xpadneo.enable = true;
  hardware.steam-hardware.enable = true;
  boot.kernelModules = [ "uinput" "joydev" ];
}
