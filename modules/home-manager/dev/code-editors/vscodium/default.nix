{pkgs, ...}: {
  imports = [
    ./settings.nix
    ./extensions.nix
    ./activity-bar.nix
  ];

  # Must be programs.vscodium, not programs.vscode with a vscodium package.
  # The latter writes to Visual Studio Code's paths, so extensions land in
  # ~/.vscode/extensions while VSCodium only reads ~/.vscode-oss/extensions.
  programs.vscodium = {
    enable = true;
    mutableExtensionsDir = true;
    package = pkgs.vscodium.override {commandLineArgs = "--no-sandbox";};
  };
}
