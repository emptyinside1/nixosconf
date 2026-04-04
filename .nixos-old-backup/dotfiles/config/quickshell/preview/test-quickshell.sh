#!/usr/bin/env bash

# ---- Quickshell Preview Runner ----

# Path to the preview config
# We use absolute path to be sure
CONFIG_PATH="$(pwd)/dotfiles/config/quickshell/preview/preview.qml"

echo "🚀 Запуск Quickshell Preview..."
echo "--------------------------------------------------"
echo "Панель появится сверху через секунду."
echo "Чтобы открыть лаунчер (аналог Rofi), выполните в другом терминале:"
echo "   quickshell --ipc 'launcher.toggle()'"
echo "--------------------------------------------------"
echo "Нажмите [ENTER], чтобы остановить тест и вернуться к Waybar."

# Запуск через nix shell для изоляции
# Используем -p для указания пути к файлу
nix shell nixpkgs#quickshell --command quickshell -p "$CONFIG_PATH" &
QUICKSHELL_PID=$!

# Ожидание ввода пользователя
read -r

# Завершение
echo "🛑 Остановка Quickshell..."
kill $QUICKSHELL_PID
echo "✅ Готово. Вы вернулись в исходное состояние."
