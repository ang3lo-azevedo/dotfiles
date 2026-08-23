{
  writeShellScriptBin,
  podman,
  dockerTools,
}: let
  tplmapImage = dockerTools.pullImage {
    imageName = "zarkones/tplmap";
    imageDigest = "sha256:59f21b28cb87fbd21c2f139aa01d5b4639e28008048c6a7a48620724f0f04143";
    sha256 = "sha256-zKtZ3AxjRoM5s+krWKg2P+CquGf83RSreuNxbhfFObg=";
    finalImageName = "zarkones/tplmap";
    finalImageTag = "latest";
  };
in
  writeShellScriptBin "tplmap" ''
    # Load the image offline if it doesn't already exist in podman
    if ! ${podman}/bin/podman image exists zarkones/tplmap:latest; then
      echo "Loading tplmap container image offline..."
      ${podman}/bin/podman --storage-opt ignore_chown_errors=true load -i ${tplmapImage}
    fi

    # tplmap container wrapper
    exec ${podman}/bin/podman --storage-opt ignore_chown_errors=true run -it --rm --entrypoint python zarkones/tplmap:latest /app/tplmap.py "$@"
  ''
