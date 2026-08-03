{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    binwalk
  ];
}
