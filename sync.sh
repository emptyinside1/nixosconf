# ~/nixos/sync.sh
#!/usr/bin/env bash

cd ~/nixos

# Добавить изменения
git add .

# Коммит с сообщением
echo "Commit message:"
read msg
git commit -m "$msg"

# Отправить на GitHub
git push

