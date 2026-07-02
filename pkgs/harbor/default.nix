{
  appimageTools,
  callPackage,
}: let
  sources = callPackage ../_sources/generated.nix {};
  pname = "harbor";
  inherit (sources.harbor) version src;
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = _: [];

    meta = {
      description = "Custom Stremio client built for adventure";
      homepage = "https://github.com/harborstremio/harbor";
    };
  }
