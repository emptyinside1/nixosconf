{ inputs, config, pkgs, pkgs-stable, ... }:

{
  # ===== HOME.PACKAGES (альтернатива для конфиг файлов) =====
  home.file = {
    # Кастомные shell скрипты
    ".local/bin/nix-search" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        # Быстрый поиск пакетов в nixpkgs
        query="$1"
        nix search nixpkgs "$query" --json | jq 'keys[]'
      '';
    };

    ".local/bin/nix-cleanup" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        echo "🧹 Очищаю nix store..."
        nix-collect-garbage -d
        echo "✅ Готово!"
      '';
    };

    ".local/bin/nix-cleanall" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        echo "Удаление старых поколений профиля"            
        sudo nix-env --delete-generations old
        echo "Удаление старых поколений системы (из загрузчика)"
        sudo nix-collect-garbage -d
        echo "Оптимизирование хранилища (убирает дубликаты файлов, может занять время)"
        nix-store --optimise
        echo "Готово."
      '';
    };

    # Пример конфига если нужно копировать целый файл
    # ".config/my-app/config" = {
    #   source = ./dotfiles/my-app-config;
    # };
  };

}
