{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    pspy
  ];
}
