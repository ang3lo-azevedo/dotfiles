{pkgs}: let
  inherit (pkgs) lib;
in
  {
    id,
    hash,
    patches ? [],
  }:
    pkgs.stdenv.mkDerivation {
      name = "chromium-extension-${id}";
      src = pkgs.fetchurl {
        url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=113.0&x=id%3D${id}%26installsource%3Dondemand%26uc";
        sha256 = hash;
      };
      nativeBuildInputs = [pkgs.unzip pkgs.patch];
      unpackPhase =
        ''
          mkdir -p $out
          unzip -q $src -d $out || true
        ''
        + lib.optionalString (patches != []) ''
          for p in ${lib.escapeShellArgs patches}; do
            patch -p1 -d $out < "$p"
          done
        '';
      installPhase = ''
        # unzip already put things in $out
        true
      '';
    }
