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
      Type = "oneshot";
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
      shadow # Added for useradd
    ];

    preStart = ''
      mkdir -p /opt/zapret
      cp -f /etc/zapret.conf /opt/zapret/config
      
      ln -sf ${pkgs.zapret}/usr/share/zapret/common /opt/zapret/common
      ln -sf ${pkgs.zapret}/usr/share/zapret/ipset /opt/zapret/ipset
      ln -sf ${pkgs.zapret}/usr/share/zapret/files /opt/zapret/files
      mkdir -p /opt/zapret/init.d/sysv
      ln -sf ${pkgs.zapret}/usr/share/zapret/functions /opt/zapret/init.d/sysv/functions
      ln -sf ${pkgs.zapret}/bin/zapret /opt/zapret/init.d/sysv/zapret

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
    
    FWTYPE="iptables"
    
    # Enable NFQWS explicitly
    NFQWS_ENABLE=1
    TPWS_ENABLE=0
    
    MODE="nfqws"
    MODE_FILTER="none"
    
    # Strategy from blockcheck
    NFQWS_OPT="--dpi-desync=fake --dpi-desync-ttl=6"
    
    NFQWS_PORTS_TCP="80,443"
    NFQWS_PORTS_UDP="443"
    
    # NixOS already has 'nobody' user
    WS_USER="nobody"
    
    DISABLE_IPV6=0
    INIT_APPLY_FW=1
    PIDDIR="/opt/zapret"
    
    NFQWS="${pkgs.zapret}/bin/nfqws"
    TPWS="${pkgs.zapret}/bin/tpws"
    IPSET_CR="$ZAPRET_BASE/ipset/create_ipset.sh"
  '';
}
