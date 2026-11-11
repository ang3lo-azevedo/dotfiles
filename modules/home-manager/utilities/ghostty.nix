{
  programs.ghostty = {
    enable = true;
    settings = {
      window-decoration = "none";
      window-padding-y = "12,12";
      window-padding-x = "12,12";
      window-padding-balance = true;
      confirm-close-surface = false;

      # Niri spawns Ghostty from the CLI, where single-instance defaults off, so every
      # window cold-starts GTK/GPU/fontconfig. Forcing it on lets new windows attach to
      # the running process and open instantly.
      gtk-single-instance = true;
    };
  };
}
