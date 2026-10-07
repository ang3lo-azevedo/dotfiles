{pkgs, ...}: {
  home.packages = with pkgs; [
    libewf
  ];
}
