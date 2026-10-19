{pkgs, ...}: {
  home.packages = with pkgs; [
    lava
  ];
}
