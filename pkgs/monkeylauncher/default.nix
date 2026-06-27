{
  lib,
  stdenv,
  makeWrapper,
  python3,
  python3Packages,
  gtk3,
  glib,
  pango,
  callPackage,
}: let
  sources = callPackage ../_sources/generated.nix {};
  pythonEnv = python3.withPackages (_: [python3Packages.pygobject3]);

  typelibPath = lib.makeSearchPath "lib/girepository-1.0" [
    gtk3
    glib
    pango
  ];
in
  stdenv.mkDerivation rec {
    pname = "monkeylauncher";
    version = sources.monkeylauncher.version;
    src = sources.monkeylauncher.src;

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
        runHook preInstall

        mkdir -p $out/{bin,share/{monkeylauncher,applications,icons/hicolor/256x256/apps}}

        # GUI: run Python script with GTK3/PyGObject env
        cp src/MonkeyLauncherGUI.py $out/share/monkeylauncher/
        makeWrapper ${pythonEnv}/bin/python3 $out/bin/monkeylauncher \
          --add-flags "$out/share/monkeylauncher/MonkeyLauncherGUI.py" \
          --prefix GI_TYPELIB_PATH : '${typelibPath}'

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
