{pkgs, ...}: {
  home.packages = with pkgs; [
    vleapp
  ];
}
