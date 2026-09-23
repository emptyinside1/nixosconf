{ inputs, config, pkgs, ... }:
let
  pkgs-stable = pkgs.stable;
in
{
  home.packages = with pkgs; [
    # Программы GUI.
    telegram-desktop
    pkgs-stable.lutris
    protonup-qt
    qbittorrent
    qemu
    winboat
    mpv
    heroic
    obsidian
    antigravity-ide
    discord
    godot
    android-studio
    (pkgs.callPackage ../../pkgs/youtube-music/default.nix {})

    # Терминальные программы.
    pkgs-stable.htop
    rclone
    btop
    nvtopPackages.nvidia
    unimatrix
    fastfetch
    zapret
    cava

    # Завимимости.
    bc
    ffmpeg
    nodejs
    bat
    gcc
    gnumake
    unzip
    ripgrep
    fd
    lazygit
    lua-language-server
    nil 
    nixd
    stylua
    prettier
    tree-sitter
    tmux
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  
  programs.pay-respects = {
    enable = true;
    # выберите нужную оболочку
    enableZshIntegration = true;   # если используете zsh
    # enableBashIntegration = true;  # если используете bash
    # enableFishIntegration = false; # и т.д.
    options = [ "--alias" "f" ];   # как будет называться команда (аналог `thefuck`)
    # при желании можно передать опции самому pay-respects:
    # options = [ "--ai" ];
  };

  programs.zen-browser = {
    enable = true;
  };
  
  services.syncthing = {
    enable = true;
    overrideDevices = true;     # Применяет настройки устройств из конфига
    overrideFolders = true;     # Применяет настройки папок из конфига
    settings = {
      devices = {
        "phone" = { id = "5SHMTFT-TQYJIWY-RN2P6YJ-QYYIZPR-V43YROM-CJLCY34-RLNDORS-GASPFAZ"; };
      };
      folders = {
        "wl7z3-ishy7" = {
          path = "${config.home.homeDirectory}/Documents/Obs";
          label = "Obs";
          devices = [ "phone" ]; # Синхронизировать с телефоном
        };
      };
    };
  };

}
