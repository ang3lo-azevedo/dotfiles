{ pkgs, inputs, ... }:
let
  runtimeLibPath = pkgs.lib.makeLibraryPath [
    pkgs.gtk3
    pkgs.glib
    pkgs.cairo
  ];

  gsettingsDataPath = pkgs.lib.concatStringsSep ":" [
    "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
  ];

  archi = pkgs.stdenvNoCC.mkDerivation {
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
      makeWrapper "$out/opt/archi/Archi" "$out/bin/archi" \
        --set GTK_THEME Adwaita:light \
        --set SWT_GTK3 1 \
        --prefix XDG_DATA_DIRS : "${gsettingsDataPath}" \
        --prefix LD_LIBRARY_PATH : "${runtimeLibPath}"

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
