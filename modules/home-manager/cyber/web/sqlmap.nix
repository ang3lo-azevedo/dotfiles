{pkgs, ...}: {
  home.packages = with pkgs; [
    sqlmap
  ];
}
