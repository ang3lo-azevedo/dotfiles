{ pkgs, ... }:
{
  home.packages = with pkgs; [
    glaumar_repo.qrookie
  ];
}