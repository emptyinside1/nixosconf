{ config, pkgs, ... }:

{
  # Настройка DNS over HTTPS (исправлен синтаксис для NixOS 26.05)
  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        DNSSEC = "true";
        Domains = "~.";
        FallbackDNS = "1.1.1.1 8.8.8.8";
        DNSOverHTTPS = "yes";
      };
    };
  };

  # Используем встроенный модуль NixOS! 
  # Да, он уже есть в unstable ветке, которую ты используешь.
  services.zapret = {
    enable = true;
    configureFirewall = true;
    
    # Настройки для TCP (80, 443) и UDP (443)
    httpSupport = true; # TCP 80
    udpSupport = true;  # UDP 443 (QUIC)
    udpPorts = [ "443" ];
    
    # Передаем параметры напрямую в nfqws
    # Стратегия, которая сработала для Youtube в твоем логе: fake,multisplit + midsld
    params = [
      "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-fake-quic=${pkgs.zapret}/usr/share/zapret/files/fake/quic_initial_www_google_com.bin --new"
      "--filter-tcp=80,443 --dpi-desync=fake,multisplit --dpi-desync-ttl=5 --dpi-desync-split-pos=midsld"
    ];
  };

  # Мы удаляем кастомный systemd.services.zapret и environment.etc,
  # так как встроенный модуль services.zapret сделает всё сам.
}
