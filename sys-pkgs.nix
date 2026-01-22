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

  programs.pay-respects = {
    enable = true;
    # выберите нужную оболочку
    enableZshIntegration = true;   # если используете zsh
    enableBashIntegration = true;  # если используете bash
    enableFishIntegration = false; # и т.д.
    alias = "f";                   # как будет называться команда (аналог `thefuck`)
    # при желании можно передать опции самому pay-respects:
    # options = [ "--ai" ];
  };

  services.zapret = {
    enable = true;
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

}
