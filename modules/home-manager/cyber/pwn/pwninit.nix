{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    pwninit
    patchelf
    elfutils
  ];
}
