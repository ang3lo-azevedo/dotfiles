{ pkgs, ... }:

let
  version = "1.0.25.1";
  appimage = pkgs.fetchurl {
    url = "https://github.com/aelrased/NuvioDesktop/releases/download/v${version}.fix/Nuvio-${version}-x86_64.AppImage";
    hash = "sha256-6J786cLc4cf7NCTtG/y3PRMORtxPMR3ht8aPZL1y9fM=";
  };
in
pkgs.appimageTools.wrapType2 {
  pname = "nuvio-desktop";
  inherit version;
  src = appimage;

  extraPkgs = _: [ ];

  meta = {
    description = "Modern media hub for Stremio - NuvioDesktop";
    longDescription = ''
      Nuvio Desktop is a modern media hub for Stremio, built with Kotlin Multiplatform
      and Compose Multiplatform. It provides a modern interface for managing Stremio
      addons and streaming content.
    '';
    homepage = "https://github.com/aelrased/NuvioDesktop";
  };
}
