{pkgs, ...}: {
  imports = [
    ./options.nix
    ./extensions
    ./zen-browser
    ./helium-browser
  ];
  home.packages = with pkgs; [
    ungoogled-chromium
  ];
}
