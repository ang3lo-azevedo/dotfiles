{ pkgs, ... }:
let
  version = "2.1.4";

  src = pkgs.fetchzip {
    url = "https://github.com/balena-io/etcher/releases/download/v${version}/balenaEtcher-linux-x64-${version}.zip";
    hash = "sha256-sOCPABzBXLDWSIMtsdIyc6pv8lERvBBLi8H3lKqWFtk=";
    stripRoot = false;
  };

  runtimeLibraryPath = pkgs.lib.makeLibraryPath (with pkgs; [
    glib
    gtk3
    nss
    nspr
    dbus
    atk
    at-spi2-atk
    cairo
    pango
    cups
    libxkbcommon
    udev
    alsa-lib
    libdrm
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    xorg.libXcursor
    xorg.libXtst
    xorg.libXi
    libgbm
    expat
  ]);

  balenaEtcher = pkgs.stdenvNoCC.mkDerivation {
    pname = "balena-etcher";
    inherit version;

    inherit src;

    nativeBuildInputs = [
      pkgs.copyDesktopItems
      pkgs.makeWrapper
    ];

    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "balenaEtcher";
        desktopName = "balenaEtcher";
        genericName = "Disk image flasher";
        exec = "balenaEtcher %U";
        categories = [
          "System"
          "Utility"
        ];
      })
    ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/libexec/balenaEtcher $out/bin
      cp -R ${src}/balenaEtcher-linux-x64/. $out/libexec/balenaEtcher/
      chmod +x $out/libexec/balenaEtcher/balena-etcher

      makeWrapper $out/libexec/balenaEtcher/balena-etcher $out/bin/balenaEtcher \
        --prefix LD_LIBRARY_PATH : "${runtimeLibraryPath}:$out/libexec/balenaEtcher"

      runHook postInstall
    '';

    meta = {
      description = "Disk image flasher";
      homepage = "https://etcher.balena.io/";
      platforms = pkgs.lib.platforms.linux;
      mainProgram = "balenaEtcher";
    };
  };
in
{
  home.packages = [
    balenaEtcher
  ];
}