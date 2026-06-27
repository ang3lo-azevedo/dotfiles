{pkgs, ...}: {
  home.packages = with pkgs; [
    monkeylauncher
    umu-launcher
  ];
}
