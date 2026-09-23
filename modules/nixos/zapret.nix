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
    
    httpSupport = true;
    udpSupport = false;
    
    params = [
      "--dpi-desync=multisplit"
      "--dpi-desync-split-pos=10,midsld"
      "--dpi-desync-split-seqovl=1"
    ];
  };
}
