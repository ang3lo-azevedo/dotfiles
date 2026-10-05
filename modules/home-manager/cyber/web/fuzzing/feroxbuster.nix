{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    feroxbuster
  ];
}
