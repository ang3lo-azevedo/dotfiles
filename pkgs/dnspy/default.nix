{
  lib,
  stdenv,
  fetchurl,
  unzip,
  wineWow64Packages,
}:

stdenv.mkDerivation rec {
  pname = "dnspy";
  version = "6.5.1";

  src = fetchurl {
    url = "https://github.com/dnSpyEx/dnSpy/releases/download/v${version}/dnSpy-net-win64.zip";
    sha256 = "7b4e16ffdeded7e27785377f110388e4afb52250d4606246d52154e935be0ee8";
  };

  nativeBuildInputs = [
    unzip
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/dnspy
    cp -r * $out/opt/dnspy/

    mkdir -p $out/bin
    cat > $out/bin/dnspy <<EOF
#!/bin/sh
export WINEPREFIX="\$HOME/.wine-dnspy"
export WINEARCH=win64
# Suppress wine-mono and wine-gecko popups, dnSpy brings its own .NET 8 runtime
export WINEDLLOVERRIDES="mscoree=;mshtml="
# Suppress some wine debug output
export WINEDEBUG="-all"
exec ${wineWow64Packages.waylandFull}/bin/wine $out/opt/dnspy/dnSpy.exe "\$@"
EOF
    chmod +x $out/bin/dnspy

    mkdir -p $out/share/applications
    cat > $out/share/applications/dnspy.desktop <<EOF
[Desktop Entry]
Name=dnSpy
Exec=dnspy
Type=Application
Categories=Development;
Comment=.NET debugger and assembly editor
EOF

    runHook postInstall
  '';

  meta = with lib; {
    description = ".NET debugger and assembly editor";
    homepage = "https://github.com/dnSpyEx/dnSpy";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
  };
}
