{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    hashid
  ];
}
