{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    dwarf2json
  ];
}
