{ config, pkgs, ... }:

{
  # Install zapret package
  environment.systemPackages = [ pkgs.zapret ];

  # Configure zapret service
  # Since there is no official module, we use systemd directly
  systemd.services.zapret = {
    description = "Zapret DPI bypass service";
    after = [ "network-online.target" "syslog.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "forking";
      # The script handles daemonizing itself
      ExecStart = "${pkgs.zapret}/bin/zapret start";
      ExecStop = "${pkgs.zapret}/bin/zapret stop";
      Restart = "on-failure";
      # zapret config location
      # We explicitly do NOT use WorkingDirectory because it must exist BEFORE preStart
      # Instead, we will handle directory changes inside the scripts or just not rely on it
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
      # This runs before ExecStart. 
      # Systemd applies WorkingDirectory even to preStart, which causes the failure if it doesn't exist.
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
    
    # Base directory for scripts and binaries
    ZAPRET_BASE="${pkgs.zapret}/usr/share/zapret"
    # Read-write directory for pids and dynamic configs
    ZAPRET_RW="/opt/zapret"
    
    # Override binary paths to use absolute paths from nix store
    NFQWS="${pkgs.zapret}/bin/nfqws"
    TPWS="${pkgs.zapret}/bin/tpws"
    IPSET_CR="$ZAPRET_BASE/ipset/create_ipset.sh"
    
    FWTYPE="iptables"
    SET_MAXELEM=524288
    IPSET_OPT="hashsize 262144 maxelem $SET_MAXELEM"
    
    # Mode: nfqws or tpws
    MODE="nfqws"
    
    # Filter mode: none, ipset, hostlist, autohostlist
    MODE_FILTER="none"
    
    # NFQWS parameters
    NFQWS_OPT_DESYNC="--dpi-desync=split2"
    
    # Ports to intercept
    NFQWS_PORTS_TCP="80,443"
    NFQWS_PORTS_UDP="443"
    
    # User to run daemons
    WS_USER="nobody"
    
    # IP versions
    DISABLE_IPV6=0
    
    # Interface filtering (auto detects if empty)
    IFACE_LAN=""
    IFACE_WAN=""
    
    # Init settings
    INIT_APPLY_FW=1
    
    # PID directory
    PIDDIR="/opt/zapret"
  '';
}
