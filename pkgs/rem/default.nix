{ pkgs, ... }:

let
  sources = pkgs.callPackage ../_sources/generated.nix { };
  version = sources.rem.version;
  appimage = sources.rem.src;
in
pkgs.appimageTools.wrapType2 {
  pname = "rem";
  inherit version;
  src = appimage;

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
