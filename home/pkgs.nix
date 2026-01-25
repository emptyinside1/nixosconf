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
    gearlever

    # Терминальные программы.
    zsh
    starship
    oh-my-zsh
    pkgs-stable.htop
    btop
    unimatrix
    fastfetch
    zapret

    # Завимимости.
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

}
