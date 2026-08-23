{pkgs, ...}: {
  home.packages = with pkgs; [
    wordlists
  ];
}
