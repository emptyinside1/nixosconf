{ config, pkgs, ... }:

{
  # Enable networking
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "1.1.1.1"     # Cloudflare DNS
    "8.8.8.8"     # Google DNS
  ];
  networking.dhcpcd.enable = false;

  # Enable systemd-resolved for correct TUN mode DNS handling
  services.resolved.enable = true;

  # Enable Avahi
  services.avahi.enable = true;

  # Firewall configuration (Syncthing)
  networking.firewall.enable = true;
  networking.firewall.checkReversePath = "loose";
  networking.firewall.allowedTCPPorts = [ 8384 22000 47984 47985 47986 47987 47988 47989 47990 48010 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 5353 1900 47998 47999 48000 48010 ];

  # Включаем программу Tailscale (это наш невидимый интернет-кабель)
  services.tailscale.enable = true;

  # Example SSH client configurations
  programs.ssh.extraConfig = ''
    Host example-server
      HostName 100.64.0.1
      User admin
      IdentityFile ~/.ssh/id_ed25519
      StrictHostKeyChecking accept-new
  '';


  # Добавляем настройку для zapret
  # zapret требует включенного ip_forwarding для некоторых режимов
  # и определенных параметров ядра для работы с очередями NFQUEUE
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
