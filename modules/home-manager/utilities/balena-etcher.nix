{ inputs, pkgs, ... }:
let
  # Extract version from package.json in the flake input
  version = (builtins.fromJSON (builtins.readFile "${inputs.balena-etcher}/package.json")).version;

  upstreamSource = inputs.balena-etcher;

  runtimeLibraryPath = pkgs.lib.makeLibraryPath (with pkgs; [
    glib
    gtk3
    nss
    nspr
    dbus
    atk
    at-spi2-atk
    cairo
    pango
    cups
    libxkbcommon
    udev
    alsa-lib
    libdrm
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    xorg.libXcursor
    xorg.libXtst
    xorg.libXi
    libgbm
    expat
  ]);

  balenaEtcher = pkgs.stdenvNoCC.mkDerivation {
    pname = "balena-etcher";
    inherit version;

    src = upstreamSource;

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
      pkgs.copyDesktopItems
      pkgs.makeWrapper
    ];

    buildInputs = with pkgs; [
      glib
      gtk3
      nss
      nspr
      dbus
      atk
      at-spi2-atk
      cairo
      pango
      cups
      libxkbcommon
      udev
      alsa-lib
      libdrm
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libxcb
      xorg.libXcursor
      xorg.libXtst
      xorg.libXi
      libgbm
      expat
    ];

    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "balenaEtcher";
        desktopName = "balenaEtcher";
        genericName = "Disk image flasher";
        exec = "balenaEtcher %U";
        categories = [
          "System"
          "Utility"
        ];
      })
    ];

    dontUnpack = true;

    buildPhase = ''
      cd ${upstreamSource}
      npm ci --production
      npm run build:electron:linux
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/libexec/balenaEtcher $out/bin
      
      # Copy built electron app
      if [ -d "dist/balenaEtcher-linux-x64" ]; then
        cp -R dist/balenaEtcher-linux-x64/. $out/libexec/balenaEtcher/
      elif [ -d "${upstreamSource}/dist/balenaEtcher-linux-x64" ]; then
        cp -R ${upstreamSource}/dist/balenaEtcher-linux-x64/. $out/libexec/balenaEtcher/
      else
        # Fallback: use pre-built binary if available
        cp -R ${upstreamSource}/* $out/libexec/balenaEtcher/ || true
      fi
      
      chmod +x $out/libexec/balenaEtcher/balena-etcher 2>/dev/null || true

      makeWrapper $out/libexec/balenaEtcher/balena-etcher $out/bin/balenaEtcher \
        --prefix LD_LIBRARY_PATH : "${runtimeLibraryPath}:$out/libexec/balenaEtcher"

      runHook postInstall
    '';

    meta = {
      description = "Disk image flasher";
      homepage = "https://etcher.balena.io/";
      platforms = pkgs.lib.platforms.linux;
      mainProgram = "balenaEtcher";
    };

    passthru = {
      inherit upstreamSource;
    };
  };
in
{
  home.packages = [
    balenaEtcher
  ];
}