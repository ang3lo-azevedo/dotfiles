{pkgs, ...}: {
  home.packages = with pkgs; [
    networkminer
  ];
}
