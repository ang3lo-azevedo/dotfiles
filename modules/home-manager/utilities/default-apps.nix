{
  # The declared defaults still reach ~/.local/share/applications/mimeapps.list.
  # Leaving the higher-priority ~/.config copy unmanaged keeps it a normal file,
  # so "Open with" in a file manager can save a different default.
  xdg.configFile."mimeapps.list".enable = false;

  # Open folders in a GUI file manager. Apps that hand a directory to xdg-open
  # (the Switch emulators' "Open Mod Data Location", file-manager links, ...)
  # cannot launch a terminal file manager from that context, so the default has
  # to be a graphical one. Terminal yazi stays available on its own.
  xdg.mimeApps.defaultApplications."inode/directory" = ["org.gnome.Nautilus.desktop"];
}
