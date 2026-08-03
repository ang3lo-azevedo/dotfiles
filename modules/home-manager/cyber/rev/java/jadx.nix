{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    jadx
  ];
}
