{ config, pkgs, ... }:

{
  imports =
    [ # Этот файл генерируется автоматически при установке. 
      # В нем хранятся UUID дисков и модули ядра. Не удаляй его.
      ./hardware-configuration.nix
    ];

  # =====================================================================
  # 1. ЗАГРУЗЧИК И БАЗОВАЯ СИСТЕМА
  # =====================================================================
  # Настройка загрузчика (оставь systemd-boot или grub в зависимости от твоей системы) 
  # Включаем старый добрый GRUB
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # ВАЖНО: Укажи тут свой диск (sda, nvme0n1 и т.д.)
 
  # Настройка временной зоны и локали
  time.timeZone = "UTC"; # Рекомендуется UTC для серверов
  i18n.defaultLocale = "ru_RU.UTF-8";

  # =====================================================================
  # 2. ОПТИМИЗАЦИЯ ДЛЯ НОУТБУКА (БЕЗ СПЯЩЕГО РЕЖИМА)
  # =====================================================================
  # ВАЖНО: Сервер-ноутбук не должен засыпать при закрытии крышки.
  # Это игнорирует события закрытия крышки во всех режимах питания.
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
  };

  # Полностью отключаем цели (targets) systemd, отвечающие за сон и гибернацию.
  # Это железная гарантия того, что ОС не попытается уснуть сама.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  
  # На всякий случай отключаем действия по критическому разряду батареи, 
  # так как на старых ноутбуках контроллер батареи часто глючит и шлет ложные сигналы.
  services.upower.enable = true;
  services.upower.percentageAction = 0; # Игнорировать критический заряд

  # =====================================================================
  # 3. СЕТЬ И БЕЗОПАСНЫЙ УДАЛЕННЫЙ ДОСТУП (TAILSCALE)
  # =====================================================================
  networking.hostName = "homeserver"; # Имя твоего сервера
  networking.networkmanager.enable = true; # Полезно, если сервер подключен по Wi-Fi

  # Включаем Tailscale для создания приватной Mesh-сети (VPN).
  # Это позволит подключаться к серверу откуда угодно без белого IP.
  # После применения конфига нужно будет выполнить в консоли: sudo tailscale up
  services.tailscale.enable = true;

  networking.firewall = {
    enable = true;
    # Доверяем интерфейсу Tailscale, чтобы все сервисы были доступны внутри VPN
    trustedInterfaces = [ "tailscale0" ];
    # Открываем порты для внешнего мира (если сервер смотрит в локалку напрямую)
    allowedTCPPorts = [ 22 80 443 ]; 
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # =====================================================================
  # 4. SSH И УПРАВЛЕНИЕ ПОЛЬЗОВАТЕЛЯМИ
  # =====================================================================
  services.openssh = {
    enable = true;
    settings = {
      # Полностью отключаем вход по паролю. Авторизация только по SSH-ключам!
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      # Запрещаем логин напрямую под root для безопасности
      PermitRootLogin = "no";
    };
  };

  # Создаем твоего пользователя-администратора
  users.users.admin = {
    isNormalUser = true;
    description = "Server Administrator";
    # Добавляем в группы: wheel (для sudo) и docker (для управления контейнерами)
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    
    # [ВСТАВЬ_СЮДА] публичные SSH-ключи (id_rsa.pub или id_ed25519.pub)
    # от твоего основного ПК и телефона (например, из Termius)
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI...[КЛЮЧ_ОТ_ПК]..."
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI...[КЛЮЧ_ОТ_ТЕЛЕФОНА]..."
    ];
  };

  # =====================================================================
  # 5. КОНТЕЙНЕРИЗАЦИЯ (DOCKER)
  # =====================================================================
  # Docker понадобится для запуска Telegram-ботов, игровых серверов и прочего.
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    # Автоматическая очистка старых и неиспользуемых образов (экономит место на диске)
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # =====================================================================
  # 6. ФАЙЛОВОЕ ХРАНИЛИЩЕ / ОБЛАКО (NEXTCLOUD)
  # =====================================================================
  # Nextcloud — полноценное личное облако (аналог Google Drive).
  # NixOS автоматически поднимет Nginx и PostgreSQL для его работы.
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30; # Используем актуальную ветку пакета
    hostName = "nextcloud.local"; # [ВСТАВЬ_ДОМЕН] или IP Tailscale, по которому будешь заходить
    
    # Настройка базы данных и кэширования (улучшает работу на старом железе)
    database.createLocally = true;
    configureRedis = true;
    maxUploadSize = "16G";
    
    # ВАЖНО: Прежде чем применять конфигурацию (nixos-rebuild),
    # создай этот файл и запиши туда пароль админа Nextcloud:
    # sudo mkdir -p /var/secrets && echo "твой_сложный_пароль" | sudo tee /var/secrets/nextcloud-admin-pass
    config = {
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = "/var/secrets/nextcloud-admin-pass";
    };
    
    settings = {
      # Если заходишь через Tailscale IP, добавь его сюда
      trusted_domains = [ "100.x.y.z" ]; # [ВСТАВЬ_TAILSCALE_IP]
      default_phone_region = "RU";
    };
  };

  # АЛЬТЕРНАТИВА: Если Nextcloud окажется слишком "тяжелым", закомментируй блок выше
  # и раскомментируй блок ниже для легковесной Samba-шары (сетевая папка):
  /*
  services.samba = {
    enable = true;
    securityType = "user";
    shares = {
      cloud = {
        path = "/mnt/storage"; # Убедись, что папка существует
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };
  */

  # =====================================================================
  # 7. СИСТЕМНЫЕ ПАКЕТЫ И УТИЛИТЫ
  # =====================================================================
  # Только самые необходимые консольные утилиты, чтобы не засорять систему
  environment.systemPackages = with pkgs; [
    git
    htop
    tmux         # Для фоновых сессий в консоли
    wget
    curl
    docker-compose
    tailscale
  ];

  # Очистка старых поколений системы для экономии места
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  # Оптимизация хранилища пакетов (хардлинки дубликатов)
  nix.settings.auto-optimise-store = true;

  # Эта настройка указывает версию NixOS, с которой была установлена система.
  # НЕ меняй ее при обновлениях системы, это сломает обратную совместимость стейта.
  system.stateVersion = "24.05"; # [ВСТАВЬ_СВОЮ_ВЕРСИЮ], обычно 23.11 или 24.05
}
