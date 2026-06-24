{pkgs, ...}: {
  home.packages = with pkgs; [
    stremio-linux-shell
  ];
}
