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
      shadow
    ];

    preStart = ''
      mkdir -p /opt/zapret/init.d/sysv
      
      # Copy configuration
      cp -f /etc/zapret.conf /opt/zapret/config
      
      # Link necessary directories from nix store to /opt/zapret
      # Using -n (no-dereference) is CRITICAL here to prevent ln from 
      # trying to create links INSIDE the target directories on second run
      ln -sfn ${pkgs.zapret}/usr/share/zapret/common /opt/zapret/common
      ln -sfn ${pkgs.zapret}/usr/share/zapret/ipset /opt/zapret/ipset
      ln -sfn ${pkgs.zapret}/usr/share/zapret/files /opt/zapret/files
      
      # Correct path for functions and script
      ln -sfn ${pkgs.zapret}/usr/share/zapret/init.d/sysv/functions /opt/zapret/init.d/sysv/functions
      ln -sfn ${pkgs.zapret}/bin/zapret /opt/zapret/init.d/sysv/zapret

      # Create empty lists if they don't exist
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
    
    # Enable NFQWS
    NFQWS_ENABLE=1
    TPWS_ENABLE=0
    
    MODE="nfqws"
    MODE_FILTER="none"
    
    # Strategy from blockcheck (Confirmed working for you)
    NFQWS_OPT="--dpi-desync=fake --dpi-desync-ttl=6"
    
    NFQWS_PORTS_TCP="80,443"
    NFQWS_PORTS_UDP="443"
    
    WS_USER="nobody"
    DISABLE_IPV6=0
    INIT_APPLY_FW=1
    PIDDIR="/opt/zapret"
    
    # Absolute paths to binaries
    NFQWS="${pkgs.zapret}/bin/nfqws"
    TPWS="${pkgs.zapret}/bin/tpws"
    IPSET_CR="$ZAPRET_BASE/ipset/create_ipset.sh"
  '';
}
