{...}: {
  imports = [
    ./audio.nix
    ./display-brightness.nix
    ./egpu-disconnect.nix
    ./egpu-mouse-fix.nix
    ./fingerprint.nix
    ./gaze.nix
    ./fn-keys
    ./webcam.nix
    ./usbc-video-fix.nix
  ];
}
