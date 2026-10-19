{pkgs, ...}: {
  home.packages = with pkgs; [
    lleapp
  ];
}
