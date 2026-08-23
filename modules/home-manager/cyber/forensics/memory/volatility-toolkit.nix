{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    volatility-toolkit
  ];
}
