{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    whatweb
  ];
}
