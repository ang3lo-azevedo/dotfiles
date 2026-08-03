{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    apktool
  ];
}
