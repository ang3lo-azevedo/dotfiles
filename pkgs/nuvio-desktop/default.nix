{ lib
, stdenv
, fetchurl
, unzip
, rsync
, wineWow64Packages
, makeWrapper
}:

let
  pname = "nuvio-desktop";
  version = "0.1.19";
  build = "62";
  
  wine = wineWow64Packages.waylandFull;
  
  # Fetch the portable ZIP from GitHub releases
  src = fetchurl {
    url = "https://github.com/CreepsoOff/NuvioDesktop/releases/download/${version}/Nuvio-${version}_${build}-x64-portable.zip";
    hash = "sha256-Vsx1ucDLqkSRM8cfDOjTmVTkjh+eK7XMB6zQusDldpk=";
    name = "nuvio-desktop-${version}-portable.zip";
  };

in
stdenv.mkDerivation {
  inherit pname version src;
  
  nativeBuildInputs = [ unzip makeWrapper rsync ];
  sourceRoot = ".";
  
  dontConfigure = true;
  dontBuild = true;
  dontPatchShebangs = true;
  dontUpdateAutotoolsGnuConfigScripts = true;
  
  unpackPhase = ''
    ${unzip}/bin/unzip -qo "$src" 2>&1 | grep -v "warning:" || true
  '';
  
  installPhase = ''
    mkdir -p $out/bin $out/share/applications $out/share/nuvio
    
    # Use rsync to copy with permission override for read-only files
    if [ -d "Nuvio" ]; then
      ${rsync}/bin/rsync -avx --chmod=Du+rwx,Fu+rw Nuvio/ $out/share/nuvio/ 2>/dev/null || true
      if [ ! -f "$out/share/nuvio/Nuvio.exe" ]; then
        # Fallback: copy everything at root level
        ${rsync}/bin/rsync -avx --chmod=Du+rwx,Fu+rw . $out/share/nuvio/ 2>/dev/null || true
      fi
    else
      ${rsync}/bin/rsync -avx --chmod=Du+rwx,Fu+rw . $out/share/nuvio/ 2>/dev/null || true
    fi
    
    # Verify executable exists
    if [ ! -f "$out/share/nuvio/Nuvio.exe" ]; then
      echo "ERROR: Nuvio.exe not found after extraction!"
      ls -la "$out/share/nuvio/" 2>/dev/null | head -20 || find "$out/share/nuvio" -name "*.exe" 2>/dev/null || true
      exit 1
    fi
    
    # Create wrapper script to run with wine
    makeWrapper ${wine}/bin/wine $out/bin/nuvio-desktop \
      --set WINEPREFIX "$HOME/.wine-nuvio" \
      --add-flags "$out/share/nuvio/Nuvio.exe"
    
    # Create desktop entry
    cat > $out/share/applications/nuvio-desktop.desktop << 'DESKTOP'
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Nuvio Desktop
    Comment=Modern media hub for Stremio
    Exec=nuvio-desktop %U
    Icon=multimedia-video-player
    Categories=Media;Video;
    Keywords=stremio;addons;media;streaming;
    Terminal=false
    DESKTOP
  '';
  
  meta = with lib; {
    description = "Modern media hub for Stremio - Kotlin Multiplatform Windows Desktop";
    longDescription = ''
      Nuvio Desktop is an unofficial Windows port of the Nuvio media hub application,
      built with Kotlin Multiplatform and Compose Multiplatform. It provides a modern
      interface for managing Stremio addons and streaming content.
    '';
    homepage = "https://github.com/CreepsoOff/NuvioDesktop";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "nuvio-desktop";
  };
}
