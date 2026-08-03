{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    raccoon-scanner
  ];
}
