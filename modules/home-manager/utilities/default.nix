{pkgs, ...}: let
  # update-flake wraps `nix flake update` with a Hydra build-status check.
  # Updating while Hydra still has pending builds means many closures will not
  # be in the binary cache yet, forcing expensive local compilations.
  update-flake = pkgs.writeShellApplication {
    name = "update-flake";
    runtimeInputs = [pkgs.curl pkgs.nix];
    text = ''
      CHANNEL="https://channels.nixos.org/nixos-unstable"

      echo "Checking nixos-unstable channel status..."
      if ! location=$(curl -sI "$CHANNEL" | grep -i "^location:" | tr -d '\r' | awk '{print $2}'); then
        echo "Warning: could not reach channels.nixos.org. Update anyway? [y/N]"
        read -r ans
        [[ "$ans" =~ ^[Yy]$ ]] || exit 0
        nix flake update "$@"
        exit 0
      fi

      # URL format: https://releases.nixos.org/nixos/unstable/nixos-26.11pre1022855.e73de5be04e0
      channel_rev=$(echo "$location" | grep -oE '[a-f0-9]{12}$')
      if [[ -z "$channel_rev" ]]; then
        echo "Warning: could not parse channel commit from: $location. Update anyway? [y/N]"
        read -r ans
        [[ "$ans" =~ ^[Yy]$ ]] || exit 0
        nix flake update "$@"
        exit 0
      fi

      echo "Channel commit: $channel_rev (binary cache is ready)"
      echo "Updating all inputs..."
      nix flake update "$@"
      echo "Pinning nixpkgs to channel commit to guarantee cache hits..."
      nix flake lock --update-input nixpkgs --override-input nixpkgs "github:NixOS/nixpkgs/$channel_rev" "$@"
    '';
  };
in {
  home.packages =
    [pkgs._7zz]
    ++ (with pkgs; [
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
    ./yazi.nix
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
    ./autodesk-fusion.nix

    ./zapzap.nix
    ./restic-browser.nix
    ./ventoy.nix
    ./calendar.nix
    ./downloads.nix
    ./auteticacaogovpt.nix
  ];
}
