{ pkgs, ... }:

let
  sources = pkgs.callPackage ../_sources/generated.nix { };
  version = sources.rem.version;
  appimage = sources.rem.src;

  appimageContents = pkgs.appimageTools.extractType2 {
    pname = "rem";
    inherit version;
    src = appimage;
  };
in
pkgs.appimageTools.wrapType2 {
  pname = "rem";
  inherit version;
  src = appimage;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/rem.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/rem.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=rem'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  extraPkgs = _: [ ];

  meta = {
    description = "Rclone desktop app";
    longDescription = ''
      REM is a desktop application based on Rclone. It allows you to browse, organize,
      and transfer files across your cloud storages effortlessly.
    '';
    homepage = "https://github.com/liriliri/rem";
  };
}
