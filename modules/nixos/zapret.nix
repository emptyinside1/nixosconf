{ config, pkgs, ... }:

{
  # Install zapret package
  environment.systemPackages = [ pkgs.zapret ];

  # Configure zapret service
  systemd.services.zapret = {
    description = "Zapret DPI bypass service";
    after = [ "network-online.target" "syslog.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "5";
      
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p /opt/zapret"
        "${pkgs.coreutils}/bin/cp -f /etc/zapret.conf /opt/zapret/config"
        "${pkgs.coreutils}/bin/touch /opt/zapret/ipset-exclude.txt /opt/zapret/ipset-whitelist.txt /opt/zapret/hostlist.txt"
        "${pkgs.zapret}/bin/zapret start-fw"
      ];
      
      # Запускаем nfqws напрямую, чтобы systemd его видел и не убивал!
      ExecStart = "${pkgs.zapret}/bin/nfqws --user=nobody --dpi-desync-fwmark=0x40000000 --qnum=200 --dpi-desync=fake --dpi-desync-ttl=6";
      
      ExecStopPost = "${pkgs.zapret}/bin/zapret stop-fw";
    };

    path = with pkgs; [
      iptables
      iproute2
      bash
      gawk
      coreutils
      gnugrep
      gnused
      curl
      procps
      nftables
      ipset
      which
      kmod
    ];
  };

  # Provide configuration file via environment.etc
  environment.etc."zapret.conf".text = ''
    ZAPRET_BASE="${pkgs.zapret}/usr/share/zapret"
    ZAPRET_RW="/opt/zapret"
    FWTYPE="iptables"
    MODE="nfqws"
    MODE_FILTER="none"
    NFQWS_OPT_DESYNC="--dpi-desync=fake --dpi-desync-ttl=6"
    NFQWS_PORTS_TCP="80,443"
    NFQWS_PORTS_UDP="443"
    WS_USER="nobody"
    DISABLE_IPV6=0
    IFACE_LAN=""
    IFACE_WAN=""
    INIT_APPLY_FW=1
    PIDDIR="/opt/zapret"
    NFQWS="${pkgs.zapret}/bin/nfqws"
    TPWS="${pkgs.zapret}/bin/tpws"
    IPSET_CR="$ZAPRET_BASE/ipset/create_ipset.sh"
  '';
}
