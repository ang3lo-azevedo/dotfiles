{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    hayabusa
  ];
}
