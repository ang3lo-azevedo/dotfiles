{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    evolve
  ];
}
