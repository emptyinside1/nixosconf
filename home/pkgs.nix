{ inputs, config, pkgs, pkgs-stable, ... }:

{
  home.packages = with pkgs; [
    # Программы GUI.
    telegram-desktop
    steam
    lutris
    protonup-qt
    qbittorrent
    qemu
    winboat
    steam
    steam-run
    #gearlever
    mpv
    heroic
    #bottles
    obsidian
    antigravity

    # Терминальные программы.
    zsh
    starship
    oh-my-zsh
    pkgs-stable.htop
    btop
    unimatrix
    fastfetch
    zapret
    gemini-cli
    cava

    # Завимимости.
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
    nodePackages.prettier
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
        "phone" = { id = "BBB4K52-HWFLJMN-YKSLZ7Q-MLVW2ID-4H26JDG-52F4V4I-D4N7WUX-YSURIAV"; };
      };
      folders = {
        "Obsidian" = {
          path = "/home/daniil/Documents/Obs";
          devices = [ "phone" ]; # Синхронизировать с телефоном
        };
      };
    };
  };
}
