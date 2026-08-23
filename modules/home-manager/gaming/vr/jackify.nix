{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    pkgs.jackify
  ];
}
