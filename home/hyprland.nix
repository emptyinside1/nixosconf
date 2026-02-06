{ pkgs, config, lib, ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/.nixos/dotfiles/config";
in
{
  # Пакеты, необходимые для работы конфига JaKooLit
  home.packages = with pkgs; [
    # Hyprland Core & Utils
    waybar
    rofi
    swaynotificationcenter
    wlogout
    swww          # Демон обоев
    # hyprlock
    hypridle
    hyprpicker
    thunar
    mpvpaper

    # Скриншоты и буфер обмена
    grim
    slurp
    swappy
    wl-clipboard
    cliphist
    pamixer

    # Темизация
    wallust
    nwg-look
    # qt5ct
    # qt6ct
    libsForQt5.qt5ct
    kdePackages.qt6ct
    
    # Терминал (используется Kitty в конфигах)
    kitty
    
    # Утилиты для скриптов (громкость, яркость, плеер, уведомления)
    jq
    imagemagick
    libnotify
    playerctl
    brightnessctl
    pavucontrol
    parallel
    networkmanagerapplet
  ];

  # Симлинки на конфиги. Используем mkOutOfStoreSymlink, чтобы редактировать файлы на месте.
  xdg.configFile = {
    
    "hypr" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/hypr"; };
    "waybar" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/waybar"; };
    "rofi" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/rofi"; };
    "kitty" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/kitty"; };
    "swaync" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/swaync"; };
    "wlogout" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/wlogout"; };
    "wallust" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/wallust"; };
    "btop" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/btop"; };
    "cava" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/cava"; };
    "fastfetch" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/fastfetch"; };
    
  };
}
