{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    sstv
  ];
}
