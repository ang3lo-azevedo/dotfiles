{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  alsa-lib,
  dbus,
  glib,
  gtk3,
  libGL,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libXrender,
  libXtst,
  libxcb,
  libxkbcommon,
  nspr,
  nss,
  pango,
  pipewire,
  fontconfig,
  freetype,
}: let
  version = "140.13.0esr-bb25";
in
  stdenv.mkDerivation {
    pname = "betterbird";
    inherit version;

    src = fetchurl {
      url = "https://www.betterbird.eu/downloads/LinuxArchive/betterbird-${version}.en-US.linux-x86_64.tar.xz";
      hash = "sha256-00bAxsT43N4gT5fy14DWhVMLkWPYZLzNXBSUVjlLocA=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      copyDesktopItems
    ];

    buildInputs = [
      alsa-lib
      dbus
      glib
      gtk3
      libGL
      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXrandr
      libXrender
      libXtst
      libxcb
      libxkbcommon
      nspr
      nss
      pango
      pipewire
      fontconfig
      freetype
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/betterbird $out/bin

      cp -r ./* $out/lib/betterbird/
      chmod +x $out/lib/betterbird/betterbird
      chmod +x $out/lib/betterbird/betterbird-bin

      makeWrapper $out/lib/betterbird/betterbird $out/bin/betterbird \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [nss]}

      for size in 16 32 48 64 128 256; do
        icon=$out/lib/betterbird/chrome/icons/default/default$size.png
        if [ -f "$icon" ]; then
          dir=$out/share/icons/hicolor/''${size}x''${size}/apps
          mkdir -p "$dir"
          ln -s "$icon" "$dir/betterbird.png"
        fi
      done
      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "betterbird";
        exec = "betterbird %U";
        icon = "betterbird";
        comment = "Fine-tuned version of Mozilla Thunderbird";
        desktopName = "Betterbird";
        genericName = "Mail Client";
        categories = ["Network" "Email" "Office"];
        mimeTypes = [
          "x-scheme-handler/mailto"
          "message/rfc822"
        ];
        startupWMClass = "betterbird";
        terminal = false;
      })
    ];

    meta = with lib; {
      description = "Fine-tuned version of Mozilla Thunderbird with extra features and bugfixes";
      homepage = "https://www.betterbird.eu";
      license = licenses.mpl20;
      mainProgram = "betterbird";
      platforms = ["x86_64-linux"];
      maintainers = [];
    };
  }
