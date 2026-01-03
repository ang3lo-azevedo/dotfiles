{ pkgs
, ...
}:
{
  home.packages = with pkgs; [
    iwmenu
  ];
}