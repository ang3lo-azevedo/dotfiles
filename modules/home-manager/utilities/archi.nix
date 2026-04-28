{ pkgs, inputs, ... }:
let
  # Import the archi package definition from the nixpkgs commit
  nixpkgsArchi = inputs.archi-nixpkgs;
  
  archiPackage = (import "${nixpkgsArchi}/pkgs/by-name/ar/archi/package.nix" {
    inherit (pkgs) lib stdenv fetchurl autoPatchelfHook makeWrapper jdk libsecret glib webkitgtk_4_1 wrapGAppsHook3 copyDesktopItems makeDesktopItem _7zz;
    
    # Provide nixosTests - normally from ${nixpkgs}/nixos/tests/archi.nix but not needed for home-manager
    nixosTests = { archi = null; };
  }).overrideAttrs (old: {
    passthru = (old.passthru or {}) // { 
      tests = { archi = null; };
      updateScript = null;
    };
  });
in
{
  home.packages = [ archiPackage ];
}
