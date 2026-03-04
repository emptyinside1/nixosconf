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

    ".local/bin/run-dotify" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        
        # Path to your AppImage
        APPIMAGE="$HOME/Documents/AppImage/Dotify.AppImage"
        
        # GStreamer paths from NixOS
        GST_LIBS="${pkgs.gst_all_1.gstreamer.out}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-ugly}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-libav}/lib/gstreamer-1.0"
        
        # Crucial for GStreamer to find its scanner in NixOS
        export GST_PLUGIN_SCANNER="${pkgs.gst_all_1.gstreamer.out}/libexec/gstreamer-1.0/gst-plugin-scanner"
        export GST_PLUGIN_SYSTEM_PATH_1_0="$GST_LIBS"
        export GST_PLUGIN_PATH="$GST_LIBS"

        # WebKit/Wayland/Nvidia workarounds
        export WEBKIT_DISABLE_COMPOSITING_MODE=1
        export WEBKIT_USE_GLX=1
        
        # Force use of system GLib and GStreamer core to avoid "undefined symbol"
        export LD_LIBRARY_PATH="${pkgs.glib.out}/lib:${pkgs.gst_all_1.gstreamer.out}/lib:${pkgs.gst_all_1.gst-plugins-base}/lib:$LD_LIBRARY_PATH"

        if [[ -f "$APPIMAGE" ]]; then
          echo "🚀 Запуск Dotify через appimage-run с фиксами GStreamer..."
          # Используем appimage-run для создания FHS окружения
          ${pkgs.appimage-run}/bin/appimage-run "$APPIMAGE" "$@"
        else
          echo "❌ Ошибка: Не удалось найти $APPIMAGE"
        fi
      '';
    };

    # Пример конфига если нужно копировать целый файл
    # ".config/my-app/config" = {
    #   source = ./dotfiles/my-app-config;
    # };
  };

}
