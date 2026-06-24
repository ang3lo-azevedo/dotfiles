{pkgs, ...}: {
  home.packages = with pkgs; [
    xr.kaon
  ];
}
