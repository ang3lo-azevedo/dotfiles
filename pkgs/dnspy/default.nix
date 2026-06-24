{
  lib,
  stdenv,
  fetchurl,
  unzip,
  icoutils,
  wineWow64Packages,
  callPackage,
}: let
  sources = callPackage ../_sources/generated.nix {};
in
  stdenv.mkDerivation rec {
    pname = "dnspy";
    version = sources.dnspy.version;

    src = sources.dnspy.src;

    icon = fetchurl {
      url = "https://raw.githubusercontent.com/dnSpyEx/dnSpy/master/dnSpy/dnSpy/Images/dnSpy.ico";
      sha256 = "10yabklfvvj3gv9810d3sffbrrzj0gzksd8l528h9id3wnwzsdzk";
    };

    breezeDarkTheme = fetchurl {
      url = "https://gist.githubusercontent.com/Zeinok/ceaf6ff204792dde0ae31e0199d89398/raw/wine-breeze-dark.reg";
      sha256 = "0b3nzzndrsjq4772wq17vp5b35fs9bv43jy7lnx8d2rclah96vgj";
    };

    nativeBuildInputs = [
      unzip
      icoutils
    ];

    sourceRoot = ".";

    installPhase = ''
          runHook preInstall

          mkdir -p $out/opt/dnspy
          cp -r * $out/opt/dnspy/

          mkdir -p $out/bin
          cat > $out/bin/dnspy <<EOF
      #!/bin/sh
      export WINEPREFIX="\$HOME/.wine-dnspy"
      export WINEARCH=win64
      export WINEDEBUG="-all"

      # Create a temporary registry file for visual enhancements
      REG_FILE=\$(mktemp)
      cat <<'REGE' > \$REG_FILE
      Windows Registry Editor Version 5.00

      ; Enable ClearType font smoothing
      [HKEY_CURRENT_USER\Control Panel\Desktop]
      "FontSmoothing"="2"
      "FontSmoothingGamma"=dword:00000578
      "FontSmoothingOrientation"=dword:00000001
      "FontSmoothingType"=dword:00000002

      ; Enable Wine's built-in Dark Theme (fixes Win98/XP look)
      [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ThemeManager]
      "ThemeActive"="1"
      "DllName"="C:\\\\windows\\\\resources\\\\themes\\\\dark\\\\dark.msstyles"

      ; Tell Windows apps to use Dark Theme
      [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize]
      "AppsUseLightTheme"=dword:00000000
      "SystemUsesLightTheme"=dword:00000000

      ; Dark theme hints for Wine display drivers (Window decorations)
      [HKEY_CURRENT_USER\Software\Wine\X11 Driver]
      "Theme"="Dark"
      [HKEY_CURRENT_USER\Software\Wine\Mac Driver]
      "Theme"="Dark"
      [HKEY_CURRENT_USER\Software\Wine\Wayland Driver]
      "Theme"="Dark"

      ; Replace missing Windows fonts with native Linux fonts for better WPF text rendering
      [HKEY_CURRENT_USER\Software\Wine\Fonts\Replacements]
      "Consolas"="DejaVu Sans Mono"
      "Segoe UI"="DejaVu Sans"
      "Microsoft Sans Serif"="DejaVu Sans"
      "Tahoma"="DejaVu Sans"
      REGE

      # Apply the registry files silently
      ${wineWow64Packages.waylandFull}/bin/wine regedit ${breezeDarkTheme} &>/dev/null
      ${wineWow64Packages.waylandFull}/bin/wine regedit \$REG_FILE &>/dev/null
      rm -f \$REG_FILE

      exec ${wineWow64Packages.waylandFull}/bin/wine $out/opt/dnspy/dnSpy.exe "\$@"
      EOF
          chmod +x $out/bin/dnspy

          mkdir -p $out/share/icons/hicolor/256x256/apps
          icotool -x "$icon" -o $out/share/icons/hicolor/256x256/apps/dnspy.png

          mkdir -p $out/share/applications
          cat > $out/share/applications/dnspy.desktop <<EOF
      [Desktop Entry]
      Name=dnSpy
      Exec=dnspy
      Icon=dnspy
      Type=Application
      Categories=Development;
      Comment=.NET debugger and assembly editor
      EOF

          runHook postInstall
    '';

    meta = with lib; {
      description = ".NET debugger and assembly editor";
      homepage = "https://github.com/dnSpyEx/dnSpy";
      license = licenses.gpl3Only;
      platforms = ["x86_64-linux"];
    };
  }
