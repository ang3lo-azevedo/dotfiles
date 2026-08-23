{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    caido-desktop
    caido-cli
  ];
}
