{pkgs, ...}: {
  home.packages = with pkgs; [
    pwninit
    patchelf
    elfutils
  ];
}
