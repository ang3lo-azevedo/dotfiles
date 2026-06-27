{
  lib,
  pkgs,
  callPackage,
}: let
  sources = callPackage ../_sources/generated.nix {};
in
  pkgs.stdenv.mkDerivation {
    inherit (sources.linoffice) pname version src;

    dontBuild = true;

    installPhase = ''
            runHook preInstall

            mkdir -p $out/share/linoffice
            cp -r apps config gui $out/share/linoffice/
            cp linoffice.sh $out/share/linoffice/

            # The script resolves config paths relative to SCRIPT_DIR_PATH, but the nix
            # store is read-only. Redirect them to XDG_CONFIG_HOME instead.
            substituteInPlace $out/share/linoffice/linoffice.sh \
              --replace-fail \
                'readonly CONFIG_PATH="$(realpath "''${SCRIPT_DIR_PATH}/config/linoffice.conf")"' \
                'readonly CONFIG_PATH="''${XDG_CONFIG_HOME:-$HOME/.config}/linoffice/linoffice.conf"' \
              --replace-fail \
                'readonly COMPOSE_PATH="$(realpath "''${SCRIPT_DIR_PATH}/config/compose.yaml")"' \
                'readonly COMPOSE_PATH="''${XDG_CONFIG_HOME:-$HOME/.config}/linoffice/compose.yaml"'

            # Wrapper: seed config dir from defaults on first run, then exec the patched script.
            # @BINPATH@ and @STORE@ are substituted after the heredoc is written.
            mkdir -p $out/bin
            cat > $out/bin/linoffice << 'WRAPPER'
      #!/usr/bin/env bash
      export PATH="@BINPATH@:$PATH"
      cfg="''${XDG_CONFIG_HOME:-$HOME/.config}/linoffice"
      mkdir -p "$cfg"
      [[ -f "$cfg/linoffice.conf" ]] || cp "@STORE@/config/linoffice.conf.default" "$cfg/linoffice.conf"
      [[ -f "$cfg/compose.yaml"   ]] || cp "@STORE@/config/compose.yaml.default"   "$cfg/compose.yaml"
      exec "@STORE@/linoffice.sh" "$@"
      WRAPPER
            substituteInPlace $out/bin/linoffice \
              --replace-fail '@BINPATH@' '${lib.makeBinPath [pkgs.freerdp pkgs.podman pkgs.podman-compose]}' \
              --replace-fail '@STORE@' "$out/share/linoffice"
            chmod +x $out/bin/linoffice

            # Desktop files ship with /PATH/ placeholders; replace with actual store paths.
            # linoffice.desktop is the Python GUI launcher and uses a different path pattern;
            # skip it and only install the individual Office app entries.
            mkdir -p $out/share/applications
            for app in word excel powerpoint outlook onenote; do
              substitute "apps/desktop/$app.desktop" "$out/share/applications/$app.desktop" \
                --replace-fail '/PATH/linoffice.sh' "$out/bin/linoffice" \
                --replace-fail '/PATH/apps' "$out/share/linoffice/apps"
            done

            mkdir -p $out/share/icons/hicolor/scalable/apps
            for app in word excel powerpoint outlook onenote; do
              [[ -f "apps/$app/icon.svg" ]] && cp "apps/$app/icon.svg" "$out/share/icons/hicolor/scalable/apps/ms-$app.svg"
            done

            runHook postInstall
    '';

    meta = {
      description = "Run Microsoft Office on Linux via a Windows VM in Podman (FreeRDP RemoteApp)";
      homepage = "https://github.com/eylenburg/linoffice";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
    };
  }
