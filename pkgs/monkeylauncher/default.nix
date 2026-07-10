{
  lib,
  stdenv,
  makeWrapper,
  wrapGAppsHook3,
  python3,
  python3Packages,
  gtk3,
  gobject-introspection,
  callPackage,
}: let
  sources = callPackage ../_sources/generated.nix {};
  pythonEnv = python3.withPackages (_: [python3Packages.pygobject3]);
in
  stdenv.mkDerivation rec {
    pname = "monkeylauncher";
    version = sources.monkeylauncher.version;
    src = sources.monkeylauncher.src;

    nativeBuildInputs = [makeWrapper wrapGAppsHook3 pythonEnv];
    buildInputs = [gtk3 gobject-introspection];

    installPhase = ''
        runHook preInstall

        mkdir -p $out/{bin,share/{monkeylauncher,applications,icons/hicolor/256x256/apps}}

        # GUI, install directly in bin so wrapGAppsHook3 picks it up
        cp src/MonkeyLauncherGUI.py $out/bin/monkeylauncher
        chmod +x $out/bin/monkeylauncher
        patchShebangs $out/bin/monkeylauncher

        # CLI
        cp src/MonkeyLauncherCLI.sh $out/share/monkeylauncher/
        makeWrapper ${stdenv.shell} $out/bin/monkeylauncher-cli \
          --add-flags "$out/share/monkeylauncher/MonkeyLauncherCLI.sh"

        # Icon
        cp src/logo.png $out/share/icons/hicolor/256x256/apps/monkeylauncher.png

        # Desktop entry
        cat > $out/share/applications/monkeylauncher.desktop <<EOF
      [Desktop Entry]
      Name=MonkeyLauncher
      Comment=Wine/Proton game launcher
      Exec=$out/bin/monkeylauncher
      Icon=monkeylauncher
      Type=Application
      Categories=Game;
      Terminal=false
      StartupNotify=true
      EOF

        runHook postInstall
    '';

    meta = with lib; {
      description = "A launcher for online-fix Windows games on Linux, built on top of umu-launcher and Proton";
      homepage = "https://github.com/SaruM4N3/MonkeyLauncher";
      license = licenses.free;
      maintainers = [];
      platforms = platforms.linux;
    };
  }
