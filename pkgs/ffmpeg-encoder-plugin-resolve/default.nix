{
  stdenvNoCC,
  unzip,
  callPackage,
}: let
  sources = callPackage ../_sources/generated.nix {};
in
  stdenvNoCC.mkDerivation {
    pname = "ffmpeg-encoder-plugin-resolve";
    inherit (sources.ffmpeg-encoder-plugin-resolve) version src;

    nativeBuildInputs = [unzip];

    unpackPhase = "unzip $src";

    installPhase = ''
      mkdir -p $out
      cp -r ffmpeg_encoder_plugin.dvcp.bundle $out/
    '';
  }
