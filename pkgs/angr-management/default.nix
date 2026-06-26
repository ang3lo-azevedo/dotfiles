{
  pkgs,
  src,
  ...
}: let
  sources = pkgs.callPackage ../_sources/generated.nix {};
in
  pkgs.appimageTools.wrapType2 {
    pname = "angr-management";
    version = sources.angr-management.version;
    src = sources.angr-management.src;

    extraPkgs = _: [];

    extraInstallCommands = ''
          # Install the icon from the provided source
          install -Dm444 ${src}/angrmanagement/resources/images/angr.png $out/share/icons/hicolor/256x256/apps/angr-management.png

          # Install the desktop file
          mkdir -p $out/share/applications
          cat > $out/share/applications/angr-management.desktop <<EOF
      [Desktop Entry]
      Name=angr-management
      Exec=angr-management
      Icon=angr-management
      Type=Application
      Categories=Development;Utility;
      Comment=GUI for angr
      EOF

          # Force the Fusion style and unset platform theme env vars: angr-management
          # ships its own Qt inside the AppImage and system Qt theme plugins are
          # incompatible, causing crashes or visual corruption without this override
          mv $out/bin/angr-management $out/bin/.angr-management-wrapped
          cat > $out/bin/angr-management <<EOF
      #!/bin/sh
      exec env -u QT_STYLE_OVERRIDE -u QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE=Fusion $out/bin/.angr-management-wrapped "\$@"
      EOF
          chmod +x $out/bin/angr-management
    '';

    meta = {
      description = "angr-management release AppImage";
    };
  }
