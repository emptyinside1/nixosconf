{ config, pkgs, ... }:

{
  # Install firefox.
  programs.firefox.enable = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      curl
      wget
      git
      openssh
      python313Packages.pip
      appimage-run
      hyprland-qt-support
      kdePackages.qtwayland
      kdePackages.qtdeclarative
      kdePackages.qt5compat
      kdePackages.qtremoteobjects
      kdePackages.qtsvg
      kdePackages.qtimageformats
      kdePackages.qtmultimedia
      kdePackages.qtwebchannel
      kdePackages.qtpositioning
      kdePackages.qtstyleplugin-kvantum
      libsForQt5.qtstyleplugin-kvantum
      libappindicator
      android-tools
      opencode
      gnome-network-displays
   ];

  programs.throne.enable = true;
  programs.throne.tunMode.enable = true;
  
  programs.zsh.enable = true;  
  programs.amnezia-vpn = {
    enable = true;
    package = pkgs.stable.amnezia-vpn; # Используем пакет из стабильной ветки через pkgs.stable
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services.flatpak.enable = true;
}
