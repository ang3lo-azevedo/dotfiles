{ appimageTools
, fetchurl
}:

let
  pname = "stremio-enhanced";
  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/REVENGE977/stremio-enhanced/releases/download/v${version}/Stremio.Enhanced-${version}.AppImage";
    hash = "sha256:04brgf3h49innf212z0gnp81pm4i8fr72a22m54hpppza23sidg7";
  };

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




