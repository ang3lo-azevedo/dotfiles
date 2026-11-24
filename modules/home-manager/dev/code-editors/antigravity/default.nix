{pkgs, ...}: {
  imports = [
    ./settings.nix
    ./cli-settings.nix
    ./extensions.nix
    ./filter-bypass.nix
  ];

  home.packages = with pkgs; [
    # Note: Antigravity CLI (`agy`) is provided with agenix secret loading via ../gemini-cli.nix

    (symlinkJoin {
      name = "google-antigravity-ide-fixed";
      paths = [google-antigravity-ide];
      postBuild = ''
        if [ -f "$out/share/applications/antigravity-ide.desktop" ]; then
          rm "$out/share/applications/antigravity-ide.desktop"
          cp ${google-antigravity-ide}/share/applications/antigravity-ide.desktop "$out/share/applications/antigravity-ide.desktop"
          chmod u+w "$out/share/applications/antigravity-ide.desktop"
          sed -i 's|^Icon=.*|Icon=${google-antigravity-ide-no-fhs}/lib/google-antigravity-ide/resources/app/resources/linux/code.png|' "$out/share/applications/antigravity-ide.desktop"
        fi
      '';
    })
  ];
}
