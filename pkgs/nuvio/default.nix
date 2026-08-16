{
  lib,
  appimageTools,
  callPackage,
}: let
  sources = callPackage ../_sources/generated.nix {};
  pname = "nuvio";
  version = sources.nuvio.version;
  src = sources.nuvio.src;

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/*.desktop -t $out/share/applications || true
      cp -r ${appimageContents}/usr/share/icons $out/share || true
    '';

    meta = with lib; {
      description = "A modern media hub for Linux Desktop built with Kotlin Multiplatform";
      homepage = "https://github.com/blarns/NuvioForLinux";
      platforms = platforms.linux;
    };
  }
