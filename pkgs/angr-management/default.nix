{ pkgs, ... }:

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

  meta = {
    description = "angr-management release AppImage";
  };
}
