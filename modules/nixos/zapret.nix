{ config, pkgs, ... }:

{
  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        DNSSEC = "false";
        Domains = "~.";
        FallbackDNS = "1.1.1.1 8.8.8.8";
        DNSOverHTTPS = "yes";
      };
    };
  };

  services.zapret = {
    enable = true;
    configureFirewall = true;
    
    # Оставляем только TCP (HTTP/HTTPS)
    httpSupport = true;
    udpSupport = false;
    
    # БЕРЕМ РОВНО ОДНУ СТРОЧКУ ИЗ ТВОЕГО BLOCKCHECK:
    # curl_test_https_tls12 ipv4 youtube.com : nfqws --dpi-desync=hostfakesplit --dpi-desync-ttl=5
    params = [
      "--dpi-desync=hostfakesplit"
      "--dpi-desync-ttl=5"
    ];
  };
}
