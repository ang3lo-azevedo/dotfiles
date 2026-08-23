{pkgs, ...}: {
  home.packages = with pkgs; [
    nuclei
  ];
}
