{pkgs, ...}: {
  home.packages = with pkgs; [
    betterbird
  ];
}
