{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    ligolo-ng
  ];
}
