{ pkgs, ... }:
{
  imports = [
    ./settings.nix
    ./extensions.nix
  ];

  home.packages = with pkgs; [
    (symlinkJoin {
      name = "google-antigravity-ide-fixed";
      paths = [ google-antigravity-ide ];
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