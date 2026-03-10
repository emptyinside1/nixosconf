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
      appimage-run

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
}
