{pkgs, ...}: let
  idaRun = /. + "/home/ang3lo/nix-config/private/ida-pro/ida94hotfix/ida-pro_94_x64linux.run";
  setupDir = "/home/ang3lo/nix-config/private/ida-pro/ida94hotfix/setup";
  setupExists = builtins.pathExists setupDir;
  idaExists = builtins.pathExists idaRun;
in {
  home.packages = with pkgs;
    if idaExists
    then [
      (ida-pro.overrideAttrs (old: {
        version = "9.4.0";
        src = idaRun;
        preferLocalBuild = true;
        allowSubstitutes = false;

        nativeBuildInputs = (builtins.filter (p: (p.pname or "") != "qtbase" && (p.pname or "") != "wrap-qt6-apps-hook" && (p.pname or "") != "qt-host-path-hook" && (p.pname or "") != "qtwayland") (old.nativeBuildInputs or [])) ++ [pkgs.nodejs];
        buildInputs =
          (builtins.filter (p: (p.pname or "") != "qtbase" && (p.pname or "") != "qtwayland") (old.buildInputs or []))
          ++ [pkgs.libxcrypt-legacy pkgs.xorg.libXtst];

        dontWrapQtApps = true;
        autoPatchelfIgnoreMissingDeps = true;

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin $out/lib $out/opt
          mkdir -p $out/.local/share/applications

          IDADIR=$out/opt
          HOME=$out

          $(cat $NIX_CC/nix-support/dynamic-linker) $src \
            --mode unattended --prefix $IDADIR --activate_idalib 0

          cp $IDADIR/libida.so $out/lib
          addAutoPatchelfSearchPath $IDADIR

          patchelf --add-needed libcrypto.so $IDADIR/libida.so || true

          mv $out/.local/share $out
          rm -r $out/.local
          rm -f $out/share/applications/com.hex*.desktop || true

          runHook postInstall
        '';

        postPhases = ["myFinalFixupPhase"];
        myFinalFixupPhase = ''
          echo "Running myFinalFixupPhase"
          for f in $(find $out/opt -type f -name "*.so*" -o -name "ida" -o -name "ida64" -o -name "idat" -o -name "idat64"); do
            if patchelf --print-rpath "$f" >/dev/null 2>&1; then
              RPATH=$(patchelf --print-rpath "$f")
              NEW_RPATH=$(echo "$RPATH" | tr ':' '\n' | grep -v -e "qtbase" -e "qtwayland" | tr '\n' ':' | sed 's/:$//')
              patchelf --set-rpath "$out/opt:$NEW_RPATH" "$f"
            fi
          done
        '';

        postInstall =
          (old.postInstall or "")
          + ''
                        # wrap idapyswitch so it can be run manually if needed
                        ln -sf $out/opt/idapyswitch $out/bin/idapyswitch || true

                        # Create manual wrapper for ida to run idapyswitch and set QT_PLUGIN_PATH
                        if [ -f $out/opt/ida ]; then
                          cat <<EOF > $out/bin/ida
            #!/bin/sh
            export QT_PLUGIN_PATH="$out/opt/plugins''${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}"
            $out/opt/idapyswitch --force-path ${pkgs.python313}/lib/libpython3.13.so >/dev/null 2>&1 || true
            exec $out/opt/ida "\$@"
            EOF
                          chmod +x $out/bin/ida
                        fi

                        # Create manual wrapper for idat
                        if [ -f $out/opt/idat ]; then
                          cat <<EOF > $out/bin/idat
            #!/bin/sh
            export QT_PLUGIN_PATH="$out/opt/plugins''${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}"
            exec $out/opt/idat "\$@"
            EOF
                          chmod +x $out/bin/idat
                        fi
          ''
          + (
            if setupExists
            then (import setupDir).postInstall
            else ""
          );
      }))
    ]
    else [];
}
