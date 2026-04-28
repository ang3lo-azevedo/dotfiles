{ pkgs, inputs, ... }:
let
  nixpkgsArchi = inputs.archi-nixpkgs;
  version = "5.9.0";
  
  archiPackage = (import "${nixpkgsArchi}/pkgs/by-name/ar/archi/package.nix" {
    inherit (pkgs) lib stdenv fetchurl autoPatchelfHook makeWrapper jdk libsecret glib webkitgtk_4_1 wrapGAppsHook3 copyDesktopItems makeDesktopItem _7zz;
    
    # Provide nixosTests - normally from ${nixpkgs}/nixos/tests/archi.nix but not needed for home-manager
    nixosTests = { archi = null; };
  }).overrideAttrs (old: {
    inherit version;
    
    src = pkgs.fetchurl {
      url = "https://github.com/archimatetool/archi.io/releases/download/${version}/Archi-Linux64-${version}.tgz";
      hash = "sha256-0/3/EZw5upB0dvyhS0sfKqp7C4tc6vGDW+O9WU5iTc8=";
    };
    
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.adwaita-icon-theme pkgs.hicolor-icon-theme ];
    
    postInstall = (old.postInstall or "") + ''
      # Re-wrap Archi with theme environment variables
      rm -f $out/bin/Archi
      makeWrapper $out/libexec/Archi $out/bin/Archi \
        --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath [ pkgs.glib pkgs.webkitgtk_4_1 ]} \
        --set WEBKIT_DISABLE_DMABUF_RENDERER 1 \
        --set GTK_THEME adwaita \
        --set GTK_USE_PORTAL 1 \
        --prefix PATH : ${pkgs.jdk}/bin \
        --prefix XDG_DATA_DIRS : "${pkgs.adwaita-icon-theme}/share:${pkgs.hicolor-icon-theme}/share"
    '';
    
    dontWrapGApps = true;
    
    passthru = (old.passthru or {}) // { 
      tests = { archi = null; };
      updateScript = pkgs.writeShellScript "update-archi" ''
        set -eu
        
        # Fetch latest release info from GitHub API
        latest=$(${pkgs.curl}/bin/curl -s https://api.github.com/repos/archimatetool/archi.io/releases/latest)
        version=$(echo "$latest" | ${pkgs.jq}/bin/jq -r '.tag_name')
        
        # Construct download URL and get hash
        url="https://github.com/archimatetool/archi.io/releases/download/$version/Archi-Linux64-$version.tgz"
        hash=$(${pkgs.nix}/bin/nix hash file --type sha256 <(${pkgs.curl}/bin/curl -sL "$url") 2>/dev/null || echo "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=")
        
        # Update the file
        sed -i "s/version = \".*\";/version = \"$version\";/" "$@"
        sed -i "s|hash = \"sha256-.*\";|hash = \"$hash\";|" "$@"
        
        echo "Updated archi from 5.9.0 to $version"
      '';
    };
  });
in
{
  home.packages = [ archiPackage ];
}
