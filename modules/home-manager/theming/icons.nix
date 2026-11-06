{
  pkgs,
  lib,
  config,
  ...
}: let
  home = config.home.homeDirectory;
  # SteamVR's only cached PNG. Its square app icon is a 32x32 JPEG, which fuzzel
  # (libpng + libresvg only) cannot load, so the wide wordmark is the usable art.
  steamVrLogo = "${home}/.local/share/Steam/appcache/librarycache/250820/logo.png";
  steamVrDesktop = "${home}/.local/share/applications/valve-steamvr.desktop";
in {
  home = {
    # Vimix-dark's index.theme sets Inherits=Papirus,Numix-Circle,Adwaita,hicolor,
    # so the many generic names it does not ship itself (btop, qt5ct/qt6ct,
    # x-office-calendar, preferences-system-network, ...) only resolve when Papirus
    # is actually installed. Without it they fall through to Adwaita/hicolor blanks.
    packages = with pkgs; [
      papirus-icon-theme
    ];

    # Steam owns that path as a plain file, so Home Manager would refuse to link
    # over it. Drop the stale copy before the link check; our managed entry (a
    # symlink) is left alone, and a Steam rewrite is cleaned up on the next switch.
    activation.dropSteamVrDesktop = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      if [ -e "${steamVrDesktop}" ] && [ ! -L "${steamVrDesktop}" ]; then
        $DRY_RUN_CMD rm -f "${steamVrDesktop}"
      fi
    '';
  };

  xdg = {
    dataFile = {
      # ImHex ships its icon only as share/pixmaps/imhex.svg, a legacy fallback
      # fuzzel does not search; mirror it into hicolor so Icon=imhex resolves.
      "icons/hicolor/scalable/apps/imhex.svg".source = "${pkgs.unstable.imhex}/share/pixmaps/imhex.svg";

      # Steam writes valve-steamvr.desktop with no Icon key, so fuzzel renders it
      # blank. Expose SteamVR's wordmark under a themed name (fuzzel resolves Icon
      # by name in hicolor, never an absolute path). The logo lives in Steam's
      # mutable cache, so it is followed by symlink rather than copied, tracking
      # re-downloads.
      "icons/hicolor/256x256/apps/steamvr.png".source =
        config.lib.file.mkOutOfStoreSymlink steamVrLogo;
    };

    desktopEntries = {
      # The nixpkgs stegsolve entry carries no Icon key; shadow it from the user
      # data dir with one pointing at a themed name Papirus provides.
      stegsolve = {
        name = "Stegsolve";
        comment = "A steganographic image analyzer, solver and data extractor for challanges";
        exec = "stegsolve";
        icon = "applications-graphics";
        categories = ["Graphics"];
        type = "Application";
      };

      # Shadow Steam's icon-less entry with one that points at the themed name above.
      valve-steamvr = {
        name = "SteamVR";
        comment = "URI handler for steamvr://";
        exec = ''"${home}/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrurlhandler" %U'';
        icon = "steamvr";
        terminal = false;
        type = "Application";
        categories = ["Game"];
        mimeType = ["x-scheme-handler/steamvr"];
      };
    };
  };
}
