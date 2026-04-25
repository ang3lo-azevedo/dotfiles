{ pkgs, inputs, ... }:
let
  archi = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "archi";
    version = "5.9.0";

    src = inputs.archi-src;
    nativeBuildInputs = [ pkgs.makeWrapper ];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/opt/archi" "$out/bin"

      # Archi upstream tarballs may unpack with or without a top-level Archi directory.
      if [ -d "$src/Archi" ]; then
        cp -r "$src/Archi/." "$out/opt/archi/"
      else
        cp -r "$src/." "$out/opt/archi/"
      fi

      chmod +x "$out/opt/archi/Archi" "$out/opt/archi/Archi.sh"
      makeWrapper "$out/opt/archi/Archi" "$out/bin/archi"

      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "Archi - ArchiMate modelling toolkit";
      homepage = "https://www.archimatetool.com/";
      license = licenses.mit;
      platforms = platforms.linux;
      mainProgram = "archi";
    };
  };
in
{
  home.packages = [ archi ];
}
