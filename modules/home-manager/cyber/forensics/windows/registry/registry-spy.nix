{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    registry-spy
  ];
}
