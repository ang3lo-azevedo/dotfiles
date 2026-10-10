{
  # The declared defaults still reach ~/.local/share/applications/mimeapps.list.
  # Leaving the higher-priority ~/.config copy unmanaged keeps it a normal file,
  # so "Open with" in a file manager can save a different default.
  xdg.configFile."mimeapps.list".enable = false;
}
