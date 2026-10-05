{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    git-dumper
  ];
}
