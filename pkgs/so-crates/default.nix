{
  writeShellScriptBin,
  podman,
  dockerTools,
  xdg-utils,
}: let
  socratesImage = dockerTools.pullImage {
    imageName = "ghcr.io/dougburks/so-crates";
    imageDigest = "sha256:89e7c948c74e89a62fc38349079939b7c28baaca9c8c5c8cbff5bc16adf2c39b";
    sha256 = "sha256-NArp9xSTFtZ7vetQp83ZwGG4jPFw0tRSW+iXWEsXHWA=";
    finalImageName = "ghcr.io/dougburks/so-crates";
    finalImageTag = "main";
  };
in
  writeShellScriptBin "so-crates" ''
    # Ensure the data directory exists
    mkdir -p "$HOME/socrates-data"

    # Load the image offline if it doesn't already exist in podman
    if ! ${podman}/bin/podman image exists ghcr.io/dougburks/so-crates:main; then
      echo "Loading SO-CRATES container image offline..."
      ${podman}/bin/podman load -i ${socratesImage}
    fi

    echo "Starting SO-CRATES container on http://localhost:8000"
    echo "Data directory: $HOME/socrates-data"

    # Open the browser in the background once the container is up
    (sleep 2 && ${xdg-utils}/bin/xdg-open http://localhost:8000 &> /dev/null) &

    exec ${podman}/bin/podman run --userns=keep-id --user $(id -u):$(id -g) \
      -v "$HOME/socrates-data":/data:Z -p 8000:8000 \
      ghcr.io/dougburks/so-crates:main
  ''
