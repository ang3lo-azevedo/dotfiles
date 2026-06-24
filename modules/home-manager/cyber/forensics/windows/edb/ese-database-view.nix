{pkgs, ...}: {
  home.packages = with pkgs; [
    ese-database-view
  ];
}
