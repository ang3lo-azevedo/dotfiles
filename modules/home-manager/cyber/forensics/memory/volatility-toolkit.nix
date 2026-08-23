{pkgs, ...}: {
  home.packages = with pkgs; [
    volatility-toolkit
  ];
}
