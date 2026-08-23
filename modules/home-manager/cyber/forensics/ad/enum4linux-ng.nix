{pkgs, ...}: {
  home.packages = with pkgs; [
    enum4linux-ng
  ];
}
