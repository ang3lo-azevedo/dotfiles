{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    ctf-dl
  ];
}
