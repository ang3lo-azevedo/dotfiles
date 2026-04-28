{ pkgs, inputs, ... }:
let
  builtinSrc = inputs.archi;

  # Extract version from package.json
  version = (builtins.fromJSON (builtins.readFile "${builtinSrc}/package.json")).version or "5";

  runtimeLibPath = pkgs.lib.makeLibraryPath [
    pkgs.gtk3
    pkgs.glib
    pkgs.cairo
  ];

  gsettingsDataPath = pkgs.lib.concatStringsSep ":" [
    "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
  ];

  # Build Archi from source
  archi = pkgs.stdenvNoCC.mkDerivation {
    pname = "archi";
    inherit version;

    src = inputs.archi;
    
    nativeBuildInputs = [
      pkgs.makeWrapper
      pkgs.unzip
    ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/opt/archi" "$out/bin"

      # Find the release directory (Archi builds are typically in releases/)
      if [ -d "$src/releases/linux" ]; then
        # If there's a releases directory structure
        find "$src/releases/linux" -maxdepth 1 -type d -name "Archi*" -exec cp -r {}/. "$out/opt/archi/" \;
      elif [ -d "$src/Archi" ]; then
        # Direct Archi directory in root
        cp -r "$src/Archi/." "$out/opt/archi/"
      else
        # Fallback: look for any Archi directory
        find "$src" -maxdepth 2 -type d -name "Archi*" -exec cp -r {}/. "$out/opt/archi/" \; -quit
      fi

      # If still empty, try the root
      if [ ! -f "$out/opt/archi/Archi" ]; then
        cp -r "$src"/* "$out/opt/archi/" 2>/dev/null || true
      fi

      if [ -f "$out/opt/archi/Archi" ]; then
        chmod +x "$out/opt/archi/Archi" "$out/opt/archi/Archi.sh" 2>/dev/null || true
      fi

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
