{
  appimageTools,
  fetchurl,
  callPackage,
}: let
  sources = callPackage ../_sources/generated.nix {};
  pname = "stremio-enhanced";
  version = sources.stremio-enhanced.version;

  src = sources.stremio-enhanced.src;

  # stremio-enhanced does not bundle a streaming server: it expects server.js at a fixed
  # path under XDG_CONFIG_HOME. The version is pinned separately from the AppImage because
  # the two are released independently and must be compatible with each other.
  serverJs = fetchurl {
    url = "https://dl.strem.io/server/v4.20.12/desktop/server.js";
    hash = "sha256:04xcishc3hw9iq7z29igc1083flwhp7ynz07n9gb7ry643fz69x5";
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      mkdir -p "$out/streamingserver"
      cp ${serverJs} "$out/streamingserver/server.js"

      mv "$out/bin/${pname}" "$out/bin/.${pname}-wrapped"
      cat > "$out/bin/${pname}" <<EOF
      #!/usr/bin/env bash
      set -euo pipefail

      config_root="\$HOME/.config"
      if [[ -v XDG_CONFIG_HOME && -n "\$XDG_CONFIG_HOME" ]]; then
        config_root="\$XDG_CONFIG_HOME"
      fi
      config_dir="\$config_root/stremio-enhanced/streamingserver"
      mkdir -p "\$config_dir"
      cp -f ${serverJs} "\$config_dir/server.js"

        exec "$out/bin/.${pname}-wrapped" "\$@"
      EOF
      chmod +x "$out/bin/${pname}"
    '';
  }
