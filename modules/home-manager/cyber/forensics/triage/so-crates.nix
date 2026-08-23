{pkgs, ...}: {
  home.packages = with pkgs; [
    so-crates
  ];
}
