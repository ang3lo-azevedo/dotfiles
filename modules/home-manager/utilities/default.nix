{pkgs, ...}: let
  # update-flake wraps `nix flake update` with a Hydra build-status check.
  # Updating while Hydra still has pending builds means many closures will not
  # be in the binary cache yet, forcing expensive local compilations.
  update-flake = pkgs.writeShellApplication {
    name = "update-flake";
    runtimeInputs = [pkgs.curl pkgs.jq pkgs.nix];
    text = ''
      HYDRA="https://hydra.nixos.org/jobset/nixos/trunk-combined/evals"

      echo "Checking Hydra trunk-combined..."
      if ! resp=$(curl -sf -H "Accept: application/json" "$HYDRA"); then
        echo "Warning: could not reach Hydra. Update anyway? [y/N]"
        read -r ans
        [[ "$ans" =~ ^[Yy]$ ]] || exit 0
        nix flake update "$@"
        exit 0
      fi

      scheduled=$(echo "$resp" | jq '.evals[0].nrscheduled')
      succeeded=$(echo "$resp" | jq '.evals[0].nrsucceeded')
      failed=$(echo "$resp"   | jq '.evals[0].nrfailed')
      total=$(echo "$resp"    | jq '.evals[0].nrbuilds')
      eval_id=$(echo "$resp"  | jq '.evals[0].id')

      echo "Latest eval #$eval_id: $succeeded succeeded, $failed failed, $scheduled pending / $total total"

      if [[ "$scheduled" -eq 0 ]]; then
        pct=$(( succeeded * 100 / total ))
        echo "Eval complete ($pct% succeeded). Running nix flake update..."
        nix flake update "$@"
      else
        pct=$(( (succeeded + failed) * 100 / total ))
        echo "Warning: $scheduled builds still pending ($pct% done). Binary cache may be incomplete."
        echo "Update anyway? [y/N]"
        read -r ans
        [[ "$ans" =~ ^[Yy]$ ]] || exit 0
        nix flake update "$@"
      fi
    '';
  };
in {
  home.packages = with pkgs; [
    jq
    nvfetcher
    pre-commit
    update-flake
  ];

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
    ./valent.nix
    ./openvpn.nix

    #./affinity.nix

    ./xournalapp.nix
    ./libreoffice.nix
    ./bambu-studio.nix

    ./zapzap.nix
    ./restic-browser.nix
    ./ventoy.nix
    ./calendar.nix
  ];
}
