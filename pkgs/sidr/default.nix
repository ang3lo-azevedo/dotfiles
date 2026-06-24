{
  lib,
  rustPlatform,
  callPackage,
}: let
  sources = callPackage ../_sources/generated.nix {};
in
  rustPlatform.buildRustPackage {
    pname = "sidr";
    version = sources.sidr.version;

    src = sources.sidr.src;

    cargoHash = "sha256-a9IHz0LwrYvPyNG9yOT2/OsC2EPBnaRLmPLv7FclZ/s=";

    doCheck = false;

    meta = with lib; {
      description = "Search Index Database Reporter";
      homepage = "https://github.com/strozfriedberg/sidr";
      license = licenses.asl20;
      maintainers = [];
      platforms = platforms.all;
    };
  }
