#!/usr/bin/env bash
# ~/.nixos/sync.sh — синхронизация конфига с GitHub

cd ~/.nixos

# Добавить изменения
git add .

# Коммит с сообщением
echo "Commit message:"
read msg
git commit -m "$msg"

# Отправить на GitHub
git push

