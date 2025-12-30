{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fastfetch
    git
    gh
  ];
}
