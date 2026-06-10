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

  # Firewall configuration
  networking.firewall.allowedTCPPorts = [ 8384 22000 47984 47985 47986 47987 47988 47989 47990 48010 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 5353 1900 47998 47999 48000 48010 ];
}
