{ pkgs
, ...
}:
{
  home.packages = with pkgs; [
    bzmenu
  ];
}