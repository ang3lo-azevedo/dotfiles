{ pkgs
, ...
}:
{
  home.packages = with pkgs; [
    pwmenu
  ];
}