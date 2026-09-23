{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/hardware.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/hyprland.nix
    ../../modules/nixos/niri.nix
    ../../modules/nixos/nix-settings.nix
    ../../modules/nixos/packages.nix
    ../../modules/nix-ld.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.configurationLimit = 3;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LC_MESSAGES = "ru_RU.UTF-8";
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager.ly.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ru, us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.daniil = {
    isNormalUser = true;
    description = "daniil";
    extraGroups = [ "networkmanager" "wheel" "adbusers" "docker" "input" "uinput" ];
    shell = pkgs.zsh;
  }; 

  virtualisation.docker.enable = true;

  security.sudo.wheelNeedsPassword = true;

  system.stateVersion = "25.11";
}
