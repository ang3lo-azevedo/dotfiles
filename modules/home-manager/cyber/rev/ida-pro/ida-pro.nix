{pkgs, ...}: {
  home.packages = with pkgs; [
    pkgs.ida-pro-personal
  ];
}
