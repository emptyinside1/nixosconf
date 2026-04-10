{ config, pkgs, ... }:

{
  # Включаем программу Tailscale (это наш невидимый интернет-кабель)
  services.tailscale.enable = true;

  # Настраиваем подключение к ноутбуку
  programs.ssh.extraConfig = ''
    Host homeserver
      # Пока что тут пишем локальный IP ноутбука (узнай его на роутере, обычно начинается на 192.168...)
      HostName 192.168.1.5 
      User root
      IdentityFile ~/.ssh/id_ed25519 # Это путь к твоему ключу-паролю
      StrictHostKeyChecking accept-new # Чтобы комп не ругался на новые подключения
  '';

}
