{
  lib,
  stdenv,
  bash,
  wine,
  winetricks,
  curl,
  wget,
  p7zip,
  cabextract,
  zenity,
  xdg-utils,
  findutils,
  gnused,
  gnugrep,
  coreutils,
  src,
}: let
  deps = [
    wine
    winetricks
    curl
    wget
    p7zip
    cabextract
    zenity
    xdg-utils
    findutils
    gnused
    gnugrep
    coreutils
  ];
in
  stdenv.mkDerivation {
    pname = "autodesk-fusion";
    version = "unstable";

    inherit src;

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/autodesk-fusion

      install -m755 files/setup/autodesk_fusion_installer_x86-64.sh \
        $out/share/autodesk-fusion/installer.sh

      cat > $out/bin/fusion360-install << 'EOF'
      #!/usr/bin/env bash
      export PATH="@DEPS@:$PATH"
      exec @BASH@/bin/bash @INSTALLER@ --install --default "$@"
      EOF
      substituteInPlace $out/bin/fusion360-install \
        --replace-fail '@DEPS@' '${lib.makeBinPath deps}' \
        --replace-fail '@BASH@' '${bash}' \
        --replace-fail '@INSTALLER@' "$out/share/autodesk-fusion/installer.sh"
      chmod +x $out/bin/fusion360-install

      cat > $out/bin/fusion360 << 'EOF'
      #!/usr/bin/env bash
      launcher="$HOME/.autodesk_fusion/bin/autodesk_fusion_launcher.sh"
      if [ ! -f "$launcher" ]; then
        echo "Fusion 360 not installed — run 'fusion360-install' first." >&2
        exit 1
      fi
      export PATH="@DEPS@:$PATH"
      exec "$launcher" "$@"
      EOF
      substituteInPlace $out/bin/fusion360 \
        --replace-fail '@DEPS@' '${lib.makeBinPath deps}'
      chmod +x $out/bin/fusion360

      runHook postInstall
    '';

    meta = {
      description = "Autodesk Fusion 360 on Linux via Wine (cryinkfly installer)";
      homepage = "https://codeberg.org/cryinkfly/Autodesk-Fusion-360-on-Linux";
      license = lib.licenses.unfreeRedistributable;
      platforms = ["x86_64-linux"];
      mainProgram = "fusion360";
    };
  }
