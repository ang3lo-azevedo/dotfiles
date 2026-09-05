{pkgs, ...}: {
  home.packages = [
    pkgs.gcr
    pkgs.dconf
    pkgs.seahorse
  ];

  # Enforce 'login' as the default keyring to fix PAM auto-unlock issues
  home.file.".local/share/keyrings/default" = {
    text = "login\n";
    force = true;
  };
}
