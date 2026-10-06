{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    subfinder
  ];
}
