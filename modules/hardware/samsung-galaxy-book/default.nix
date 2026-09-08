{...}: {
  imports = [
    ./audio.nix
    ./display-brightness.nix
    ./egpu-brightness.nix
    ./egpu-disconnect.nix
    ./fingerprint.nix
    ./gaze.nix
    ./fn-keys
    ./webcam.nix
    ./usbc-video-fix.nix
  ];
}
