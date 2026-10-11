{ pkgs, config, lib, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/.nixos/dotfiles/config";
  dotfilesBin = "${config.home.homeDirectory}/.nixos/dotfiles/bin";

  # Scripts via pkgs.writeShellScriptBin for direct PATH integration
  menu-wallpaper = pkgs.writeShellScriptBin "menu-wallpaper" (builtins.readFile ../../dotfiles/bin/menu-wallpaper);
  restore-wallpaper = pkgs.writeShellScriptBin "restore-wallpaper" (builtins.readFile ../../dotfiles/bin/restore-wallpaper);
  menu-configs = pkgs.writeShellScriptBin "menu-configs" (builtins.readFile ../../dotfiles/bin/menu-configs);
  menu-keybinds = pkgs.writeShellScriptBin "menu-keybinds" (builtins.readFile ../../dotfiles/bin/menu-keybinds);
  menu-power = pkgs.writeShellScriptBin "menu-power" (builtins.readFile ../../dotfiles/bin/menu-power);
  shot-region = pkgs.writeShellScriptBin "shot-region" (builtins.readFile ../../dotfiles/bin/shot-region);
  shot-full = pkgs.writeShellScriptBin "shot-full" (builtins.readFile ../../dotfiles/bin/shot-full);
  menu-clipboard = pkgs.writeShellScriptBin "menu-clipboard" (builtins.readFile ../../dotfiles/bin/menu-clipboard);
  menu-websearch = pkgs.writeShellScriptBin "menu-websearch" (builtins.readFile ../../dotfiles/bin/menu-websearch);
  menu-windows = pkgs.writeShellScriptBin "menu-windows" (builtins.readFile ../../dotfiles/bin/menu-windows);
  kill-active-process = pkgs.writeShellScriptBin "kill-active-process" (builtins.readFile ../../dotfiles/bin/kill-active-process);
  battery-notifier = pkgs.writeShellScriptBin "battery-notifier" (builtins.readFile ../../dotfiles/bin/battery-notifier);
  menu-bluetooth = pkgs.writeShellScriptBin "menu-bluetooth" (builtins.readFile ../../dotfiles/bin/menu-bluetooth);
  shot-active = pkgs.writeShellScriptBin "shot-active" (builtins.readFile ../../dotfiles/bin/shot-active);
  dropdown-terminal = pkgs.writeShellScriptBin "dropdown-terminal" (builtins.readFile ../../dotfiles/bin/dropdown-terminal);
  notify-layout = pkgs.writeShellScriptBin "notify-layout" (builtins.readFile ../../dotfiles/bin/notify-layout);
  change-volume = pkgs.writeShellScriptBin "change-volume" (builtins.readFile ../../dotfiles/bin/change-volume);
  change-brightness = pkgs.writeShellScriptBin "change-brightness" (builtins.readFile ../../dotfiles/bin/change-brightness);
  menu-power-profile = pkgs.writeShellScriptBin "menu-power-profile" (builtins.readFile ../../dotfiles/bin/menu-power-profile);
  menu-wifi = pkgs.writeShellScriptBin "menu-wifi" (builtins.readFile ../../dotfiles/bin/menu-wifi);
  menu-audio = pkgs.writeShellScriptBin "menu-audio" (builtins.readFile ../../dotfiles/bin/menu-audio);
  menu-monitors = pkgs.writeShellScriptBin "menu-monitors" (builtins.readFile ../../dotfiles/bin/menu-monitors);
in
{
  home.packages = with pkgs; [
    bluetuith
    # Core Niri tools & terminal utilities
    alacritty
    fuzzel
    swaylock
    mako
    mpvpaper
    wbg
    awww
    grim
    slurp
    wl-clipboard
    cliphist
    yazi
    zellij
    btop
    bat
    eza
    zoxide
    xwayland-satellite
    brightnessctl
    playerctl
    waybar
    pavucontrol
    networkmanagerapplet
    bluetuith
    libnotify

    # Preview utilities for Yazi
    ffmpegthumbnailer
    p7zip
    jq
    poppler

    # Packaged scripts
    menu-wallpaper
    restore-wallpaper
    menu-configs
    menu-keybinds
    menu-power
    shot-region
    shot-full
    menu-clipboard
    menu-websearch
    menu-windows
    kill-active-process
    battery-notifier
    menu-bluetooth
    shot-active
    dropdown-terminal
    notify-layout
    change-volume
    change-brightness
    menu-power-profile
    (pkgs.writeShellScriptBin "menu-power-profiles" ''exec ${menu-power-profile}/bin/menu-power-profile "$@"'')
    menu-wifi
    menu-audio
    menu-monitors
  ];

  # Yazi monochrome configuration
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
  };

  # Bat monochrome/base16
  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
  };

  # Eza
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    extraOptions = [
      "--group-directories-first"
      "--color=never"
    ];
  };

  # Symlinks to dotfiles
  xdg.configFile = {
    "niri" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/niri"; };
    "fuzzel" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/fuzzel"; };
    "alacritty" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/alacritty"; };
    "zellij" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/zellij"; };
    "yazi/theme.toml" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/yazi/theme.toml"; };
    "yazi/yazi.toml" = { source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/yazi/yazi.toml"; };
  };
}
