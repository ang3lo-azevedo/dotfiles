{pkgs, ...}: {
  home.packages = with pkgs; [
    rleapp
  ];
}
