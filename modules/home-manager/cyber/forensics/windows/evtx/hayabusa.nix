{pkgs, ...}: {
  home.packages = with pkgs; [
    hayabusa
  ];
}
