{pkgs, ...}: {
  home.packages =
    [
      pkgs._7zz
    ]
    ++ (with pkgs; [
      cachix
      jq
      nvfetcher
      pre-commit
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
