{
  writeShellScriptBin,
  podman,
  dockerTools,
}: let
  rsactftoolImage = dockerTools.pullImage {
    imageName = "ctftools/rsactftool";
    imageDigest = "sha256:62ec24a97a950a7c5ba84dded4eaff442ec2ff7ad7447a679b8fead2622c33e6";
    sha256 = "sha256-aI7rlV9+Bnaw2LEAp9M1qD8YL/8fCr97wNsHnirNhmE=";
    finalImageName = "ctftools/rsactftool";
    finalImageTag = "latest";
  };
in
  writeShellScriptBin "rsactftool" ''
    # Load the image offline if it doesn't already exist in podman
    if ! ${podman}/bin/podman image exists ctftools/rsactftool:latest; then
      echo "Loading RsaCtfTool container image offline..."
      ${podman}/bin/podman --storage-opt ignore_chown_errors=true load -i ${rsactftoolImage}
    fi

    # RsaCtfTool container wrapper
    # Mounts the current directory into the container's /data
    exec ${podman}/bin/podman --storage-opt ignore_chown_errors=true run -it --rm -v "$(pwd):/data" -w /data ctftools/rsactftool:latest "$@"
  ''
