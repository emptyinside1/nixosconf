{inputs, config, pkgs, pkgs-stable, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      # Твоя кастомизация здесь
      logo = {
        type = "auto";  # или "nixos_small", "nixos"
        padding = {
          top = 1;
        };
      };
      
      display = {
        separator = " → ";
        color = "white";
      };
      
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "display"
        "de"
        "wm"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "disk"
        "break"
        "colors"
      ];
    };
  };
}
