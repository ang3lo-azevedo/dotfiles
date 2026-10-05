{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    pdf-parser
  ];
}
