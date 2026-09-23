{ inputs, config, pkgs, pkgs-stable, ... }:

{
   # ===== XDG КОНФИГУРАЦИЯ (для dotfiles) =====
     /*
    # Конфиг может создавать нередактируемый извне файл прямо тут. 
    xdg.configFile = {
    # Пример: если у тебя есть свой конфиг fastfetch
    "fastfetch/config.jsonc".text = ''
      {
        "logo": "nixos_small",
        "display": {
          "separator": "  "
        }
      }
    '';

    # Пример: конфиг для другой программы
    "ripgrep/.ripgreprc".text = ''
      --max-columns=150
      --max-columns-preview
      --glob=!.git/
    '';
    };

    # Или же конфиг может ссылаться на уже существующий файл.
    xdg.configFiles = {
      "hypr/hyprland.conf".source = ./dotfiles/hyprland.conf
    };
    
    # И также может ссылаться на папку файлов.
    xdg.configFile = {
      "nvim" = {
        source = ./dotfiles/nvim;
        recursive = true;
      };
    };

  */
}
