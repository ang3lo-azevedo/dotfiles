{pkgs, ...}: {
  home.packages = with pkgs; [
    john
  ];
}
