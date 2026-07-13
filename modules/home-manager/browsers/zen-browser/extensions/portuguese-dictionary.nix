{
  pkgs,
  profileName,
  ...
}: {
  programs.zen-browser.profiles.${profileName}.extensions.packages = [pkgs.firefoxAddons.european-portuguese-spellcheck];
}
