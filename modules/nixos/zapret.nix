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
    ];

    preStart = ''
      mkdir -p /opt/zapret
      cp -f /etc/zapret.conf /opt/zapret/config
      
      # Create necessary structure for the scripts to work
      ln -sf ${pkgs.zapret}/usr/share/zapret/common /opt/zapret/common
      ln -sf ${pkgs.zapret}/usr/share/zapret/ipset /opt/zapret/ipset
      ln -sf ${pkgs.zapret}/usr/share/zapret/files /opt/zapret/files
      mkdir -p /opt/zapret/init.d/sysv
      ln -sf ${pkgs.zapret}/usr/share/zapret/init.d/sysv/functions /opt/zapret/init.d/sysv/functions
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
    
    # Using iptables as verified
    FWTYPE="iptables"
    
    # Mode: nfqws or tpws
    MODE="nfqws"
    
    # Filter mode: none, ipset, hostlist, autohostlist
    MODE_FILTER="none"
    
    # NFQWS parameters - UPDATED based on your blockcheck results
    # Strategy that worked for HTTPS: --dpi-desync=fake --dpi-desync-ttl=6
    NFQWS_OPT_DESYNC="--dpi-desync=fake --dpi-desync-ttl=6"
    
    # Ports to intercept
    NFQWS_PORTS_TCP="80,443"
    NFQWS_PORTS_UDP="443"
    
    # User to run daemons
    WS_USER="nobody"
    
    # IP versions
    DISABLE_IPV6=0
    
    # Firewall settings
    INIT_APPLY_FW=1
    
    # PID directory
    PIDDIR="/opt/zapret"
    
    # Ensure binary paths
    NFQWS="${pkgs.zapret}/bin/nfqws"
    TPWS="${pkgs.zapret}/bin/tpws"
    IPSET_CR="$ZAPRET_BASE/ipset/create_ipset.sh"
  '';
}
