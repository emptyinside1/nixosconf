{ config, pkgs, pkgs-stable, ... }:

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
  programs.amnezia-vpn = {
    enable = true;
    package = pkgs-stable.amnezia-vpn; # Используем пакет из стабильной ветки
  };
 

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
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services.flatpak.enable = true;
}
