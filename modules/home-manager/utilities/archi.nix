{ pkgs, inputs, ... }:
let
  lib = pkgs.lib;
  nixpkgsArchi = inputs.archi-nixpkgs;
  version = "5.9.0";
  
  archiPackage = (import "${nixpkgsArchi}/pkgs/by-name/ar/archi/package.nix" {
    inherit (pkgs) lib stdenv fetchurl autoPatchelfHook makeWrapper jdk libsecret glib webkitgtk_4_1 wrapGAppsHook3 copyDesktopItems makeDesktopItem _7zz;
    
    # Provide nixosTests - normally from ${nixpkgs}/nixos/tests/archi.nix but not needed for home-manager
    nixosTests = { archi = null; };
  }).overrideAttrs (old: {
    inherit version;
    
    src = pkgs.fetchurl {
      url = "https://github.com/archimatetool/archi.io/releases/download/${version}/Archi-Linux64-${version}.tgz";
      hash = "sha256-0/3/EZw5upB0dvyhS0sfKqp7C4tc6vGDW+O9WU5iTc8=";
    };
    
    passthru = (old.passthru or {}) // { 
      tests = { archi = null; };
      updateScript = null;
    };
  });
in
{
  home.packages = [ archiPackage ];
}
