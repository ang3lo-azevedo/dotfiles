{pkgs, ...}: {
  home.packages = [
    # FIXME: Back to pkgs once audacity 4.0.0 builds: on nixpkgs 09063bd1f2b3 and 02c087f3fe67
    # its generated QML code fails to compile ("reference to 'Type' is ambiguous")
    pkgs.stable.audacity
  ];
}
