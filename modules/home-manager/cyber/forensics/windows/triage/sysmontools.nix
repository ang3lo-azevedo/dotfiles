{pkgs, ...}: {
  home.packages = with pkgs; [
    sysmontools
  ];
}
