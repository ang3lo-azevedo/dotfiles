{pkgs, ...}: {
  home.packages = with pkgs; [
    dleapp
  ];
}
