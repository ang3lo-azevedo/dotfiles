{pkgs, ...}: {
  home.packages = with pkgs; [
    yara
  ];
}
