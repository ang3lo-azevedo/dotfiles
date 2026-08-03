{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    volatility2-bin
  ];
}
