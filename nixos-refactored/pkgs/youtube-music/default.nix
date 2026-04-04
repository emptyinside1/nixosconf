{ pkgs, ... }:

let
  libPath = with pkgs; lib.makeLibraryPath [
    stdenv.cc.cc
    glib
    nss
    nspr
    atk
    at-spi2-atk
    at-spi2-core
    dbus
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libXScrnSaver
    libglvnd
    cups
    alsa-lib
    gtk3
    pango
    cairo
    gdk-pixbuf
    libdrm
    mesa
    libgbm
    expat
    systemd
    libv4l
    libuuid
    pciutils
    libva
    libgpg-error
    libgcrypt
    libevdev
    libinput
    libunwind
    libusb1
    libkrb5
    e2fsprogs
    keyutils
    libxcrypt
    libxcrypt-legacy
  ];
in
pkgs.stdenv.mkDerivation rec {
  pname = "youtube-music";
  version = "3.11.0";

  src = ./youtube-music.deb;

  nativeBuildInputs = [
    pkgs.dpkg
    pkgs.autoPatchelfHook
    pkgs.makeWrapper
  ];

  buildInputs = [
    pkgs.glib
    pkgs.nss
    pkgs.nspr
    pkgs.atk
    pkgs.at-spi2-atk
    pkgs.at-spi2-core
    pkgs.libX11
    pkgs.libXcomposite
    pkgs.libXdamage
    pkgs.libXext
    pkgs.libXfixes
    pkgs.libXi
    pkgs.libXrandr
    pkgs.libXrender
    pkgs.libXtst
    pkgs.libXScrnSaver
    pkgs.libglvnd
    pkgs.cups
    pkgs.alsa-lib
    pkgs.gtk3
    pkgs.pango
    pkgs.cairo
    pkgs.gdk-pixbuf
    pkgs.libdrm
    pkgs.mesa
    pkgs.libgbm
    pkgs.expat
    pkgs.systemd
  ];

  unpackPhase = "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner";

  installPhase = ''
    mkdir -p $out
    cp -r usr/* $out/
    cp -r opt $out/

    # Fix the desktop file
    if [ -f $out/share/applications/youtube-music.desktop ]; then
      substituteInPlace $out/share/applications/youtube-music.desktop \
        --replace "Exec=\"/opt/YouTube Music/youtube-music\" %U" "Exec=\"$out/bin/youtube-music\" %U" \
        --replace "Icon=youtube-music" "Icon=$out/share/icons/hicolor/1024x1024/apps/youtube-music.png"
    fi

    # Create a wrapper in bin
    mkdir -p $out/bin
    makeWrapper "$out/opt/YouTube Music/youtube-music" "$out/bin/youtube-music" \
      --prefix LD_LIBRARY_PATH : "${libPath}" \
      --add-flags "--ozone-platform-hint=auto" \
      --add-flags "--enable-features=WaylandWindowDecorations"
  '';

  meta = with pkgs.lib; {
    description = "YouTube Music Desktop App (v3)";
    homepage = "https://th-ch.github.io/youtube-music/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
