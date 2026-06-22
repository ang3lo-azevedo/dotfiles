{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    restic-browser
  ];

  # Symlink the Agenix rclone secret into the standard location
  # so that Restic Browser (and standard rclone commands) can find it automatically.
  home.file.".config/rclone/rclone.conf".source = config.lib.file.mkOutOfStoreSymlink "/run/agenix/rclone-conf";
}
