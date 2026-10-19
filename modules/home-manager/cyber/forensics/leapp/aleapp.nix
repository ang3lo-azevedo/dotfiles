{pkgs, ...}: {
  home.packages = with pkgs; [
    aleapp
  ];
}
