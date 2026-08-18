{
  lib,
  stdenv,
  jdk17,
  openjfx17,
  ffmpeg,
  makeWrapper,
  callPackage,
  copyDesktopItems,
  makeDesktopItem,
}: let
  sources = callPackage ../_sources/generated.nix {};

  openjdk = jdk17.override {
    enableJavaFX = true;
    openjfx_jdk = openjfx17;
  };
in
  stdenv.mkDerivation rec {
    pname = "onlinefix-linux";
    version = sources.onlinefix-linux.version;
    src = sources.onlinefix-linux.src;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [makeWrapper copyDesktopItems];

    desktopItems = [
      (makeDesktopItem {
        name = "onlinefix-linux";
        exec = "onlinefix-linux";
        desktopName = "OnlineFix Linux";
        comment = "Launcher for running games with custom multiplayer fixes";
        categories = ["Game"];
      })
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/java/onlinefix-linux
      cp $src $out/share/java/onlinefix-linux/OFMELauncher.jar

      makeWrapper ${openjdk}/bin/java $out/bin/onlinefix-linux \
        --add-flags "-jar $out/share/java/onlinefix-linux/OFMELauncher.jar" \
        --prefix PATH : ${lib.makeBinPath [ffmpeg]}

      runHook postInstall
    '';

    meta = with lib; {
      description = "A simple and convenient launcher for running games with custom multiplayer fixes on Linux";
      homepage = "https://github.com/ZzEdovec/onlinefix-linux";
      platforms = platforms.linux;
    };
  }
