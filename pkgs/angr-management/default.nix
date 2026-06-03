{ pkgs, src, ... }:

let
  version = "9.2.219";
  appimage = pkgs.fetchurl {
    url = "https://github.com/angr/angr-management/releases/download/v${version}/angr-management-v${version}-x86_64.AppImage";
    hash = "sha256-Cn/89GCn+6teOgoQpVgYPtWhPYkMXw0OlsSH8YeqxQA=";
  };
in
pkgs.appimageTools.wrapType2 {
  pname = "angr-management";
  inherit version;
  src = appimage;

  extraPkgs = _: [ ];

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

    # Wrap the binary to apply Qt theme overrides
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
