{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    trufflehog
  ];
}
