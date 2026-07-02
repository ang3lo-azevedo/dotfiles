{
  appimageTools,
  callPackage,
  runCommandCC,
  writeText,
  writeShellScript,
}: let
  sources = callPackage ../_sources/generated.nix {};
  pname = "harbor";
  inherit (sources.harbor) version src;

  appimageContents = appimageTools.extractType2 {inherit pname version src;};

  # pw_log_topic_register was removed from pipewire's public ABI in 1.x;
  # Harbor's bundled Electron was compiled against an older pipewire that
  # expects this symbol from libjack.so.0 at startup.
  pwShim = runCommandCC "pw-log-topic-shim" {} ''
    mkdir -p $out/lib
    cc -shared -fPIC -o $out/lib/pw_log_topic_shim.so \
      ${writeText "shim.c" ''
      void pw_log_topic_register(void *t) {}
      void pw_log_topic_unregister(void *t) {}
    ''}
  '';

  wrapper = writeShellScript "harbor" ''
    export LD_PRELOAD="${pwShim}/lib/pw_log_topic_shim.so''${LD_PRELOAD:+:$LD_PRELOAD}"
    exec "$(dirname "$0")/.harbor-unwrapped" "$@"
  '';
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/Harbor.png \
        $out/share/icons/hicolor/256x256/apps/harbor.png
      install -m 444 -D ${appimageContents}/usr/share/applications/Harbor.desktop \
        $out/share/applications/harbor.desktop
      sed -i 's|^Exec=.*|Exec=harbor %u|' $out/share/applications/harbor.desktop

      mv $out/bin/harbor $out/bin/.harbor-unwrapped
      cp ${wrapper} $out/bin/harbor
      chmod +x $out/bin/harbor
    '';

    meta = {
      description = "Custom Stremio client built for adventure";
      homepage = "https://github.com/harborstremio/harbor";
    };
  }
