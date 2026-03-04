{ config, pkgs, ... }:

{
  # Install firefox.
  programs.firefox.enable = true;
  
  # Install zsh.
  # programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      curl
      wget
      git
      openssh
      python313Packages.pip
      
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  programs.zsh.enable = true;  
  programs.amnezia-vpn.enable = true;

  services.zapret = {
    enable = false;
    httpSupport = true;
    httpMode = "full";
    configureFirewall = true;
    params = [ "--dpi-desync=fake" "--dpi-desync-fooling=datanoack" ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  services.flatpak.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Базовый набор библиотек, которые нужны почти всем AppImage
    glib
    nss
    nspr
    atk
    at-spi2-atk
    libdrm
    mesa
    alsa-lib
    fontconfig
    # --- Дополнительные пакеты для nix-ld.libraries ---
    stdenv.cc.cc       # Стандартная библиотека C++ (libstdc++.so.6)
    zlib               # Сжатие данных
    fuse3              # Для запуска AppImage без распаковки
    icu                # Поддержка разных кодировок и языков
    libxkbcommon       # Раскладки клавиатуры
    libsecret          # Хранение паролей (часто просит Electron)
    dbus               # Межпроцессное общение
    expat              # XML парсер
    systemd            # Библиотека libudev.so.1
    libxml2            # Еще один XML парсер
    curl               # Сетевые запросы
    openssl            # Шифрование и SSL
    
    # Мультимедиа и звук
    libpulseaudio      # Звук (PulseAudio/Pipewire)
    pipewire           # Современный звук
    libvorbis          # Аудио-кодеки
  
    # Дополнительные X11 и Wayland зависимости
    xorg.libXrandr
    xorg.libXcomposite
    xorg.libXinerama
    wayland            # Если используете GNOME/KDE на Wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    libGL
      # Добавьте другие, если Dotify будет ругаться на отсутствие .so файлов
  ];
}
