{pkgs, ...}: {
  # Vimix-dark's index.theme sets Inherits=Papirus,Numix-Circle,Adwaita,hicolor,
  # so the many generic names it does not ship itself (btop, qt5ct/qt6ct,
  # x-office-calendar, preferences-system-network, ...) only resolve when Papirus
  # is actually installed. Without it they fall through to Adwaita/hicolor blanks.
  home.packages = with pkgs; [
    papirus-icon-theme
  ];

  # ImHex ships its icon only as share/pixmaps/imhex.svg, a legacy fallback fuzzel
  # does not search; mirror it into hicolor so Icon=imhex resolves.
  xdg.dataFile."icons/hicolor/scalable/apps/imhex.svg".source = "${pkgs.unstable.imhex}/share/pixmaps/imhex.svg";

  # The nixpkgs stegsolve entry carries no Icon key; shadow it from the user data
  # dir with one pointing at a themed name Papirus provides.
  xdg.desktopEntries.stegsolve = {
    name = "Stegsolve";
    comment = "A steganographic image analyzer, solver and data extractor for challanges";
    exec = "stegsolve";
    icon = "applications-graphics";
    categories = ["Graphics"];
    type = "Application";
  };
}
