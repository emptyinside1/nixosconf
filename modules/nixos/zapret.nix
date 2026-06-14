{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.zapret ];

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
      
      # Мультистратегия, объединяющая HTTP, HTTPS (TLS) и HTTP3 (QUIC)
      ExecStart = "${pkgs.zapret}/bin/nfqws --user=nobody --dpi-desync-fwmark=0x40000000 --qnum=200 " +
                  "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-fake-quic=${pkgs.zapret}/usr/share/zapret/files/fake/quic_initial_www_google_com.bin --new " +
                  "--filter-tcp=80 --dpi-desync=fakedsplit --dpi-desync-ttl=6 --dpi-desync-split-pos=method+2 --dpi-desync-fakedsplit-mod=altorder=1 --new " +
                  "--filter-tcp=443 --dpi-desync=fake --dpi-desync-ttl=6 --orig-ttl=1 --orig-mod-start=s1 --orig-mod-cutoff=d1";
      
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

  environment.etc."zapret.conf".text = ''
    ZAPRET_BASE="${pkgs.zapret}/usr/share/zapret"
    ZAPRET_RW="/opt/zapret"
    FWTYPE="iptables"
    MODE="nfqws"
    MODE_FILTER="none"
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
