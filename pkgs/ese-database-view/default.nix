{
  lib,
  stdenv,
  callPackage,
  wineWow64Packages,
  icoutils,
  imagemagick,
  unzip,
}:

let
  sources = callPackage ../_sources/generated.nix { };
in
stdenv.mkDerivation {
  pname = "esedatabaseview";
  version = sources.ese-database-view.version;

  nativeBuildInputs = [ icoutils imagemagick unzip ];

  src = sources.ese-database-view.src;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/esedatabaseview
    cp * $out/opt/esedatabaseview/

    wrestool -x -t 14 ESEDatabaseView.exe > icon.ico
    magick 'icon.ico[0]' esedatabaseview.png
    mkdir -p $out/share/icons/hicolor/32x32/apps
    cp esedatabaseview.png $out/share/icons/hicolor/32x32/apps/esedatabaseview.png

    mkdir -p $out/bin
    cat > $out/bin/esedatabaseview <<EOF
#!/bin/sh
export WINEPREFIX="\$HOME/.wine-esedatabaseview"
export WINEARCH=win64
export WINEDEBUG="-all"
exec ${wineWow64Packages.waylandFull}/bin/wine $out/opt/esedatabaseview/ESEDatabaseView.exe "\$@"
EOF
    chmod +x $out/bin/esedatabaseview

    mkdir -p $out/share/applications
    cat > $out/share/applications/esedatabaseview.desktop <<EOF
[Desktop Entry]
Name=ESEDatabaseView
Exec=esedatabaseview
Icon=esedatabaseview
Type=Application
Categories=Utility;
Comment=Views and displays the data of Extensible Storage Engine (ESE) database
EOF

    runHook postInstall
  '';

  meta = with lib; {
    description = "Views and displays the data of Extensible Storage Engine (ESE) database";
    homepage = "https://www.nirsoft.net/utils/ese_database_view.html";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
