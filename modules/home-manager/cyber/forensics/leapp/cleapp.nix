{pkgs, ...}: {
  home.packages = with pkgs; [
    cleapp
  ];
}
