{pkgs, ...}: let
  sources = pkgs.callPackage ../_sources/generated.nix {};
in
  pkgs.rustPlatform.buildRustPackage rec {
    pname = "scrollmpris";
    version = sources.scrollmpris.version;

    src = sources.scrollmpris.src;

    cargoHash = "sha256-esajcb2SFDJYYwexIgsqc01fI4uVOCxEZWsUpB9+qc8=";

    buildInputs = with pkgs; [dbus];
    nativeBuildInputs = with pkgs; [pkg-config];

    meta = {
      description = "Scrolling MPRIS Waybar module";
      homepage = "https://github.com/BEST8OY/ScrollMPRIS";
    };
  }
