{pkgs, ...}: {
  home.packages = with pkgs; [
    steghide
  ];
}
