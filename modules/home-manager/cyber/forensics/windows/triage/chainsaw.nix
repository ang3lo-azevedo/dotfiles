{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    chainsaw
  ];
}
