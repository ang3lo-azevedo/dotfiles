{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    regripper
  ];
}
