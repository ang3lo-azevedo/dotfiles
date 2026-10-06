{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    recon-ng
  ];
}
