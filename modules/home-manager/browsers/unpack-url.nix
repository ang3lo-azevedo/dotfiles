{pkgs}: let
  inherit (pkgs) lib;
in
  {
    name ? "chromium-extension",
    url,
    hash,
    patches ? [],
  }:
    pkgs.stdenv.mkDerivation {
      inherit name;
      src = pkgs.fetchurl {
        inherit url;
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
