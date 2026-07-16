{
  stdenv,
  dpkg,
  autoPatchelfHook,
  callPackage,
  mpv-unwrapped,
  openssl,
  webkitgtk_4_1,
  tinysparql,
}: let
  sources = callPackage ../_sources/generated.nix {};
  pname = "harbor";
  inherit (sources.harbor) version src;
in
  stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [dpkg autoPatchelfHook];
    buildInputs = [mpv-unwrapped openssl webkitgtk_4_1 tinysparql];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      dpkg-deb -x $src deb-contents

      install -Dm755 deb-contents/usr/bin/harbor $out/bin/harbor

      for size in 32x32 128x128 256x256@2; do
        install -Dm444 "deb-contents/usr/share/icons/hicolor/$size/apps/harbor.png" \
          "$out/share/icons/hicolor/$size/apps/harbor.png"
      done

      install -Dm444 deb-contents/usr/share/applications/Harbor.desktop \
        $out/share/applications/harbor.desktop
      sed -i 's|^Exec=.*|Exec=harbor %u|' $out/share/applications/harbor.desktop

      runHook postInstall
    '';

    meta = {
      description = "Custom Stremio client built for adventure";
      homepage = "https://github.com/harborstremio/harbor";
    };
  }
