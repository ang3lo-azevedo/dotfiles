{pkgs, ...}: let
  sources = pkgs.callPackage ../_sources/generated.nix {};
  version = sources.nuvio-desktop.version;
  appimage = sources.nuvio-desktop.src;
in
  pkgs.appimageTools.wrapType2 {
    pname = "nuvio-desktop";
    inherit version;
    src = appimage;

    extraPkgs = _: [];

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
