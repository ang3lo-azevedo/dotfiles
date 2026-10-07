{pkgs, ...}: {
  home.packages = with pkgs; [
    zeek
  ];
}
