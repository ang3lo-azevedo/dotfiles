{
  writeShellScriptBin,
  podman,
  dockerTools,
}: let
  cipheyImage = dockerTools.pullImage {
    imageName = "dcsunset/ciphey";
    imageDigest = "sha256:fcaefdef07db1a1f3df389f6fff00ec7b44f46430366d28c8cfa5d31885a3ae8";
    sha256 = "sha256-BxB72dYPMknxUm9ho1uocPzCej0WDl0KIThMtSPpJ08=";
    finalImageName = "dcsunset/ciphey";
    finalImageTag = "latest";
  };
in
  writeShellScriptBin "ciphey" ''
    # Load the image offline if it doesn't already exist in podman
    if ! ${podman}/bin/podman image exists dcsunset/ciphey:latest; then
      echo "Loading Ciphey container image offline..."
      ${podman}/bin/podman --storage-opt ignore_chown_errors=true load -i ${cipheyImage}
    fi

    # Run ciphey container wrapper
    exec ${podman}/bin/podman --storage-opt ignore_chown_errors=true run -it --rm dcsunset/ciphey:latest "$@"
  ''
