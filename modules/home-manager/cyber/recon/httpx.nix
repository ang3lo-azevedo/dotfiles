{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    httpx
  ];
}
