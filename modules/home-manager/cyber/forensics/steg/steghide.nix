{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    steghide
  ];
}
