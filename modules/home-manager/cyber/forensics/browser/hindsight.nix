{pkgs, ...}: {
  home.packages = with pkgs; [
    hindsight
  ];
}
