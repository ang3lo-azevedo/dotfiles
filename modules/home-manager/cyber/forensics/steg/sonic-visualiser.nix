{pkgs, ...}: {
  home.packages = with pkgs; [
    sonic-visualiser
  ];
}
