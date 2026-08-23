{pkgs, ...}: {
  home.packages = with pkgs; [
    bloodhound
  ];
}
