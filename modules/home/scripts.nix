{ inputs, config, pkgs, ... }:

let
  nix-search = pkgs.writeShellApplication {
    name = "nix-search";
    runtimeInputs = [ pkgs.nix pkgs.jq ];
    text = ''
      # Быстрый поиск пакетов в nixpkgs
      query="$1"
      nix search nixpkgs "$query" --json | jq 'keys[]'
    '';
  };

  nix-cleanup = pkgs.writeShellApplication {
    name = "nix-cleanup";
    runtimeInputs = [ pkgs.nix ];
    text = ''
      echo "🧹 Очищаю nix store..."
      nix-collect-garbage -d
      echo "✅ Готово!"
    '';
  };

  nix-cleanall = pkgs.writeShellApplication {
    name = "nix-cleanall";
    runtimeInputs = [ pkgs.nix ];
    text = ''
      echo "Удаление старых поколений профиля"
      sudo nix-env --delete-generations old
      echo "Удаление старых поколений системы (из загрузчика)"
      sudo nix-collect-garbage -d
      echo "Оптимизирование хранилища (убирает дубликаты файлов, может занять время)"
      nix-store --optimise
      echo "Готово."
    '';
  };

  run-dotify = pkgs.writeShellApplication {
    name = "run-dotify";
    runtimeInputs = [ pkgs.steam-run pkgs.e2fsprogs pkgs.libkrb5 pkgs.glib ];
    text = ''
      # Путь к вашему AppImage
      APPIMAGE="$HOME/Documents/AppImage/Dotify.AppImage"

      export GST_PLUGIN_SYSTEM_PATH_1_0="${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-ugly}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-libav}/lib/gstreamer-1.0"
      export GST_PLUGIN_SCANNER="${pkgs.gst_all_1.gstreamer.out}/libexec/gstreamer-1.0/gst-plugin-scanner"
      export GST_PLUGIN_PATH="$GST_PLUGIN_SYSTEM_PATH_1_0"

      export WEBKIT_DISABLE_COMPOSITING_MODE=1
      export WEBKIT_USE_GLX=1

      export LD_LIBRARY_PATH="${pkgs.e2fsprogs}/lib:${pkgs.libkrb5}/lib:${pkgs.glib.out}/lib:$LD_LIBRARY_PATH"

      if [[ -f "$APPIMAGE" ]]; then
        echo "🚀 Запуск Dotify через steam-run (FHS) с плагинами GStreamer..."
        steam-run "$APPIMAGE" --appimage-extract-and-run "$@"
      else
        echo "❌ Ошибка: Не удалось найти $APPIMAGE"
      fi
    '';
  };
in
{
  home.packages = [
    nix-search
    nix-cleanup
    nix-cleanall
    run-dotify
  ];
}
