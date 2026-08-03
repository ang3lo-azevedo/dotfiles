{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    one_gadget
  ];
}
