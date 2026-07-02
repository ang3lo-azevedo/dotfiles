{pkgs, ...}: {
  home.packages = with pkgs; [
    bemoji
    wtype
  ];
}
