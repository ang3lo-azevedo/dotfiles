{pkgs ? import <nixpkgs> {}}:
pkgs.writeShellScriptBin "so-crates" ''
  # Run the SO-CRATES container, mounting the current directory to /data
  # so that it can analyze local files.
  exec ${pkgs.podman}/bin/podman run -it --rm \
    -p 8000:8000 \
    -v "$PWD:/data" \
    ghcr.io/dougburks/so-crates:main "$@"
''
