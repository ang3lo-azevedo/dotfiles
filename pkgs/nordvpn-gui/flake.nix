{
  description = "GUI for NordVPN";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation rec {
          pname = "nordvpn-gui";
          version = "4.3.1";

          src = pkgs.fetchFromGitHub {
            owner = "NordSecurity";
            repo = "nordvpn-linux";
            rev = version;
            sha256 = "sha256-RVQPcztLwDp89ALP+jwqSlKYRemXXYAbv/KiY5lfOFE=";
          };

          nativeBuildInputs = with pkgs; [
            flutter
            copyDesktopItems
            makeWrapper
          ];

          buildInputs = with pkgs; [
            gtk3
            glib
            pcre
            util-linux
            libselinux
            libsepol
            libthai
            libdatrie
            libxkbcommon
            libepoxy
            dbus
          ];

          sourceRoot = "source/gui";

          prePatch = ''
            # Update version in pubspec.yaml
            sed -i 's/version: 0.0.1/version: ${version}/' pubspec.yaml
          '';

          buildPhase = ''
            export HOME=$(mktemp -d)
            flutter config --no-analytics
            flutter pub get
            flutter build linux --release
          '';

          installPhase = ''
            mkdir -p $out/opt/nordvpn-gui
            cp -r build/linux/x64/release/bundle/* $out/opt/nordvpn-gui/

            # Install icon
            mkdir -p $out/share/icons/hicolor/scalable/apps
            cp ../web/icons/icon-512.png $out/share/icons/hicolor/scalable/apps/nordvpn-gui.png

            # Install desktop file
            mkdir -p $out/share/applications
            cat > $out/share/applications/nordvpn-gui.desktop <<EOF
            [Desktop Entry]
            Type=Application
            Name=NordVPN
            Comment=GUI for NordVPN
            Exec=nordvpn-gui
            Icon=nordvpn-gui
            Terminal=false
            Categories=Network;
            EOF

            # Create wrapper script
            mkdir -p $out/bin
            makeWrapper $out/opt/nordvpn-gui/nordvpn-gui $out/bin/nordvpn-gui \
              --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath buildInputs}"
          '';

          meta = with pkgs.lib; {
            description = "GUI for NordVPN";
            homepage = "https://nordvpn.com";
            license = licenses.gpl3Only;
            platforms = [ "x86_64-linux" ];
            maintainers = [ ];
          };
        };
      }
    );
}
