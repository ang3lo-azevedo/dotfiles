{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    pkgs.harbor
  ];
}
