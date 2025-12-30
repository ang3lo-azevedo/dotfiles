{ pkgs, ... }:
{
  # Enable and configure Zsh with useful plugins
  environment.shells = with pkgs; [ zsh ];

  # Set default shell to zsh for all users
  users.defaultUserShell = pkgs.zsh;
}
