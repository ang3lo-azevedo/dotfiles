{pkgs, ...}: {
  home.packages = [
    # FIXME: Back to pkgs.unstable once it builds: from nixpkgs 09063bd1f2b3 on, expat deprecates
    # XML_GetCurrentLineNumber and bulk_extractor compiles with -Werror
    pkgs.stable.bulk_extractor
  ];
}
