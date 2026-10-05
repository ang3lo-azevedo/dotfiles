{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    rusthound-ce
  ];
}
