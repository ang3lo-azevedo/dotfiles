{ pkgs, ... }:
{
  # Add the JetBrains Mono Nerd Font to the system profile
  environment.systemPackages = with pkgs; [ nerd-fonts-jetbrains-mono ];
}