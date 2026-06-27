{
  autoPatchelfHook,
  buildFHSEnv,
  dpkg,
  lib,
  stdenv,
  sysctl,
  iptables,
  iproute2,
  procps,
  cacert,
  libxml2_13,
  libidn2,
  libnl,
  libcap_ng,
  sqlite,
  wireguard-tools,
  callPackage,
}: let
  sources = callPackage ../_sources/generated.nix {};
  inherit (sources.nordvpn) version src;

  nordVPNBase = stdenv.mkDerivation {
    pname = "nordvpn-core";
    inherit version;

    inherit src;

    buildInputs = [
      libxml2_13
      libidn2
      libnl
      libcap_ng
      sqlite
    ];

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
      stdenv.cc.cc.lib
    ];

    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      runHook preUnpack
      dpkg --extract $src .
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      mv usr/* $out/
      mv var/ $out/
      mv etc/ $out/
      runHook postInstall
    '';
  };

  nordVPNfhs = buildFHSEnv {
    name = "nordvpnd";
    runScript = "nordvpnd";

    targetPkgs = pkgs:
      with pkgs; [
        nordVPNBase
        sysctl
        iptables
        iproute2
        procps
        cacert
        wireguard-tools
      ];
  };
in
  stdenv.mkDerivation {
    pname = "nordvpn";
    inherit version;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/share
      ln -s ${nordVPNBase}/bin/nordvpn $out/bin
      ln -s ${nordVPNfhs}/bin/nordvpnd $out/bin
      ln -s ${nordVPNBase}/share/* $out/share/
      ln -s ${nordVPNBase}/var $out/
      runHook postInstall
    '';

    meta = with lib; {
      description = "CLI client for NordVPN";
      homepage = "https://www.nordvpn.com";
      license = licenses.unfreeRedistributable;
      maintainers = [];
      platforms = ["x86_64-linux"];
    };
  }
