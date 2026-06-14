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
      Type = "oneshot"; # Changed to oneshot since it manage background daemons
      RemainAfterExit = true;
      ExecStart = "${pkgs.zapret}/bin/zapret start";
      ExecStop = "${pkgs.zapret}/bin/zapret stop";
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

    preStart = ''
      mkdir -p /opt/zapret
      cp -f /etc/zapret.conf /opt/zapret/config
      touch /opt/zapret/ipset-exclude.txt
      touch /opt/zapret/ipset-whitelist.txt
      touch /opt/zapret/hostlist.txt
    '';
  };

  # Provide configuration file via environment.etc
  environment.etc."zapret.conf".text = ''
    # zapret configuration for NixOS
    ZAPRET_BASE="${pkgs.zapret}/usr/share/zapret"
    ZAPRET_RW="/opt/zapret"
    NFQWS="${pkgs.zapret}/bin/nfqws"
    TPWS="${pkgs.zapret}/bin/tpws"
    IPSET_CR="$ZAPRET_BASE/ipset/create_ipset.sh"
    
    FWTYPE="iptables"
    SET_MAXELEM=524288
    IPSET_OPT="hashsize 262144 maxelem $SET_MAXELEM"
    MODE="nfqws"
    MODE_FILTER="none"
    NFQWS_OPT_DESYNC="--dpi-desync=split2"
    NFQWS_PORTS_TCP="80,443"
    NFQWS_PORTS_UDP="443"
    WS_USER="nobody"
    DISABLE_IPV6=0
    IFACE_LAN=""
    IFACE_WAN=""
    INIT_APPLY_FW=1
    PIDDIR="/opt/zapret"
  '';
}
