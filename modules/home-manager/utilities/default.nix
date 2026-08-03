{pkgs, ...}: let
  update-flake = pkgs.writeShellApplication {
    name = "update-flake";
    runtimeInputs = [
      pkgs.curl
      pkgs.nix
    ];
    text = ''
      FLAKE_DIR="''${FLAKE_DIR:-.}"

      NIXPKGS_REF=$(grep -A1 'nixpkgs\s*=' "$FLAKE_DIR/flake.nix" | grep -oP 'nixos-[^"#/]+' || true)
      NIXPKGS_REF="''${NIXPKGS_REF:-nixos-unstable}"
      channel_rev=$(curl -sI "https://channels.nixos.org/$NIXPKGS_REF" | grep -i "^location:" | tr -d '\r' | awk '{print $2}' | grep -oE '[a-f0-9]{12}$')

      nix flake update "$@"

      if [[ -n "$channel_rev" ]]; then
        echo "Pinning nixpkgs to $channel_rev (max cache hits)..."
        nix flake update nixpkgs --override-input nixpkgs "github:NixOS/nixpkgs/$channel_rev" "$@"
      fi
    '';
  };
in {
  home.packages =
    [
      pkgs._7zz
    ]
    ++ (with pkgs; [
      cachix
      jq
      nvfetcher
      pre-commit
      update-flake
    ]);

  imports = [
    ./keyring
    ./zsh
    ./ghostty.nix
    ./popsicle.nix
    ./discord
    ./spicetify.nix
    #./pear-desktop.nix
    ./wlr-randr.nix
    ./wlr-layout-ui.nix
    ./brightnessctl.nix
    ./fastfetch.nix
    ./pavucontrol.nix
    ./nautilus.nix
    ./network-manager-applet.nix
    #./trakt-scrobbler.nix TODO: Fix Trakt Scrobbler
    #./yazi.nix
    ./superfile.nix
    ./ncdu.nix
    ./universal-android-debloater.nix
    ./kdeconnect.nix
    ./openvpn.nix
    #./linoffice.nix

    #./affinity.nix

    ./xournalapp.nix
    ./libreoffice.nix
    ./bambu-studio.nix
    #./freecad.nix
    #./autodesk-fusion.nix

    ./zapzap.nix
    ./betterbird.nix
    ./restic-browser.nix
    ./ventoy.nix
    ./calendar.nix
    ./downloads.nix
    ./auteticacaogovpt.nix
  ];
}
