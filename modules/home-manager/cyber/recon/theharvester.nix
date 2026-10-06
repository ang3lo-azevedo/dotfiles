{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    theharvester
  ];
}
