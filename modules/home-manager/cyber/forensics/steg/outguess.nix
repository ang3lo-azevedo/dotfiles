{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    outguess
  ];
}
