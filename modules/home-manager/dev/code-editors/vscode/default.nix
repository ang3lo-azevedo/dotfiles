{
  imports = [
    ./settings.nix
    ./extensions.nix
  ];

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
  };
}
