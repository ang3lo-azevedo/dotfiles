{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    naabu
  ];
}
