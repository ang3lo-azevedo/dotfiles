{ pkgs, ... }:
{
  imports = [
    ./settings.nix
    ./extensions.nix
  ];

  home.packages = with pkgs; [
    google-antigravity-ide
  ];

  xdg.desktopEntries.google-antigravity-ide = {
    name = "Google Antigravity IDE";
    exec = "google-antigravity-ide-fhs";
    icon = "${pkgs.google-antigravity-ide-no-fhs}/lib/google-antigravity-ide/resources/app/resources/linux/code.png";
    categories = [ "Development" "IDE" ];
    comment = "Google Antigravity IDE";
  };
}