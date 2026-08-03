{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    zsteg
    file
  ];
}
