{pkgs, ...}: {
  home.packages = [
    # nixpkgs removed the unqualified `gcr` attribute (hard throw, not an alias);
    # gcr_4 is the current major version, matching the rest of this GNOME-keyring stack.
    pkgs.gcr_4
    pkgs.dconf
    pkgs.seahorse
  ];

  # Enforce 'login' as the default keyring to fix PAM auto-unlock issues
  home.file.".local/share/keyrings/default" = {
    text = "login\n";
    force = true;
  };
}
