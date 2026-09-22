{pkgs, ...}: {
  imports = [
    ./settings.nix
    ./extensions.nix
  ];

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    package = pkgs.vscodium.override {commandLineArgs = "--no-sandbox";};
  };
}
