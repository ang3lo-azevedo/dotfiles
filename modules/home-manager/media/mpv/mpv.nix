{
  pkgs,
  lib,
  mpv-config,
  ...
}: let
  mpvWithVapourSynth = pkgs.mpv.override {
    mpv-unwrapped = pkgs.mpv-unwrapped.override {vapoursynthSupport = true;};
  };

  /*
     svp4BuildInputs = [
    pkgs.dbus
    pkgs.fontconfig
    pkgs.freetype
    pkgs.libX11
    pkgs.libxcb
    pkgs.stdenv.cc.cc.lib
    pkgs.xdg-utils
  ];

  svp4Runtime = pkgs.stdenv.mkDerivation {
    pname = "svp4-runtime";
    version = "4.7.0.305-1";
    src = pkgs.fetchurl {
      url = "https://www.svp-team.com/files/svp4-latest.php?linux";
      hash = "sha256-a9g6A6xDyx77DiUtErw3nLbotgN7S0lzAXzpd7Gykl4=";
    };
    nativeBuildInputs = [pkgs.gnutar pkgs.bzip2 pkgs.patchelf pkgs.proot];
    buildInputs = svp4BuildInputs;
    dontUnpack = true;
    installPhase = ''
      runHook preInstall
      tar -xjf "$src" -C "$TMPDIR"
      export HOME="$TMPDIR/home"
      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_DATA_HOME="$HOME/.local/share"
      mkdir -p "$XDG_CONFIG_HOME" "$XDG_DATA_HOME"
      mkdir -p "$TMPDIR/bin"
      for desktop_tool in xdg-desktop-menu xdg-icon-resource; do
        printf '#!/bin/sh\nexit 0\n' > "$TMPDIR/bin/$desktop_tool"
        chmod +x "$TMPDIR/bin/$desktop_tool"
      done
      export PATH="$TMPDIR/bin:$PATH"
      mkdir -p "$TMPDIR/svp4" "$out/mpv/python" "$out/python"
      chmod +x "$TMPDIR/svp4-linux.run"
      patchelf --set-interpreter "$(cat "$NIX_CC/nix-support/dynamic-linker")" "$TMPDIR/svp4-linux.run"
      LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath svp4BuildInputs}:$TMPDIR/svp4/libs" \
        proot -b "${pkgs.bash}/bin/bash:/bin/bash" "$TMPDIR/svp4-linux.run" --platform minimal --targetDir "$TMPDIR/svp4" \
          --installPackages core.flow,deps.vapoursynth
      vapoursynth_lib=$(find "$TMPDIR/svp4" -type f -name libvapoursynth.so -print -quit)
      vapoursynth_script=$(find "$TMPDIR/svp4" -type f -name libvapoursynth-script.so.0 -print -quit)
      vapoursynth_python=$(find "$TMPDIR/svp4" -type f -name vapoursynth.so -print -quit)
      python_lib=$(find "$TMPDIR/svp4" -type f -name 'libpython3.12.so.1.0' -print -quit)
      test -n "$vapoursynth_lib" -a -n "$vapoursynth_script" -a -n "$vapoursynth_python" -a -n "$python_lib"
      cp "$vapoursynth_lib" "$out/mpv/"
      cp "$vapoursynth_script" "$out/mpv/"
      cp "$vapoursynth_python" "$out/mpv/python/"
      cp -a "$(dirname "$python_lib")/." "$out/python/"
      runHook postInstall
    '';
  };
  */

  /*
     mpvWithSvp = pkgs.symlinkJoin {
    name = "mpv-with-svp";
    paths = [mpvWithVapourSynth];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      rm "$out/bin/mpv"
      makeWrapper "${mpvWithVapourSynth}/bin/mpv" "$out/bin/mpv" \
        --set SVP4_PLUGIN_DIR "/home/ang3lo/.config/mpv/svp-plugins" \
        --set SVP4_RUNTIME_DIR "${svp4Runtime}" \
        --set PYTHONHOME "${svp4Runtime}/python" \
        --set PYTHONPATH "${svp4Runtime}/mpv/python" \
        --prefix LD_LIBRARY_PATH : "${svp4Runtime}/mpv" \
        --prefix LD_LIBRARY_PATH : "${svp4Runtime}/python" \
        --prefix LD_LIBRARY_PATH : "${pkgs.stdenv.cc.cc.lib}/lib"
    '';
  };
  */

  # Filter out .vscode directory from mpv-config source
  filteredMpvConfig = lib.cleanSourceWith {
    src = mpv-config;
    filter = path: _: let
      name = baseNameOf (toString path);
    in
      name != ".vscode" && name != ".git" && name != ".gitignore";
  };
in {
  home.packages = [
    mpvWithVapourSynth
    pkgs.mpv-handler
    pkgs.vapoursynth
    pkgs.vapoursynth-mvtools
    pkgs.python3Packages.vapoursynth
    pkgs.python3Packages.guessit
    (pkgs.writeShellScriptBin "mpv-python" ''
      exec ${pkgs.python3.withPackages (ps: with ps; [guessit requests subliminal])}/bin/python3 "$@"
    '')
    pkgs.socat
  ];

  # MPV player configuration from external git repository
  # Exclude .vscode directory as it's not part of mpv config
  xdg.configFile."mpv" = {
    source = filteredMpvConfig;
    recursive = true;
  };

  # Register mpv-handler for custom protocols
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/mpv-handler" = ["mpv-handler.desktop"];
      "x-scheme-handler/mpv-handler-debug" = ["mpv-handler-debug.desktop"];
    };
  };
}
