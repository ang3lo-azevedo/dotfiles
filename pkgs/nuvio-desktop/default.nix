{pkgs, ...}: let
  # Managed manually: upstream replaced the 0.1.7-alpha asset without bumping
  # the tag, causing hash drift in nvfetcher. Update version and hash here when
  # a properly versioned release is published.
  version = "0.1.7-alpha";
  appimage = pkgs.fetchurl {
    url = "https://github.com/aelrased/NuvioDesktop/releases/download/v${version}/Nuvio-${version}-x86_64.AppImage";
    sha256 = "sha256-iPPfUiBFGetl+0de1rd59H4oXaLOih3SE7yEJyrcuvE=";
  };
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
