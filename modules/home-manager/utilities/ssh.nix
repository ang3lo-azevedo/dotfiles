{lib, ...}: {
  programs.ssh = {
    enable = true;

    # Disable the default config values to suppress the default values deprecation warning
    enableDefaultConfig = false;

    settings = {
      "gitlab.rnl.tecnico.ulisboa.pt" = {
        Host = "gitlab.rnl.tecnico.ulisboa.pt";
        User = "git";
        IdentityFile = "~/.ssh/gitlab_ist";
      };

      "github-muskyboi" = {
        Host = "github-muskyboi";
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/muskyboi";
      };

      "kitkat.serverhive.in" = {
        Port = 5156;
        User = "nos4a2";
        IdentitiesOnly = "yes";
        IdentityFile = "~/.ssh/id_ed25519";
      };

      "sigma.ist.utl.pt" = {
        Host = "sigma.ist.utl.pt sigma.tecnico.ulisboa.pt sigma02.ist.utl.pt";
        IdentitiesOnly = "yes";
        PubkeyAuthentication = "no";
        PreferredAuthentications = "password";
      };

      "eu.nixbuild.net" = {
        IdentityFile = "~/.ssh/my-nixbuild-key";
        PubkeyAcceptedKeyTypes = "ssh-ed25519";
        ServerAliveInterval = 60;
        StrictHostKeyChecking = "accept-new";
      };

      "gitlab-syssec.dpss.inesc-id.pt" = {
        Host = "gitlab-syssec.dpss.inesc-id.pt 146.193.41.153";
        User = "git";
        IdentityFile = "~/.ssh/dpss-inesc";
      };

      "github.com" = {
        User = "git";
        IdentityFile = "~/.ssh/key";
        IdentitiesOnly = "yes";
      };

      "homelab" = {
        Host = "10.42.0.10 192.168.7.*";
        IdentitiesOnly = "yes";
        IdentityFile = "~/.ssh/id_ed25519";
      };

      "*" = {
        IdentitiesOnly = "yes";
      };
    };
  };

  # OpenSSH "Bad owner or permissions" Workaround
  # Home Manager usually creates ~/.ssh/config as a symlink to the Nix store.
  # When using remote builders or certain containers, the store path may be owned by `nobody`.
  # OpenSSH strictly rejects config files that aren't owned by your user or root.
  # This trick forces Home Manager to symlink to a backup file (.ssh/config_hm),
  # and then copies it to a real, properly-owned file at .ssh/config with strict 600 permissions.
  home.file.".ssh/config".target = lib.mkForce ".ssh/config_hm";
  home.activation.copySshConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    cp -f ~/.ssh/config_hm ~/.ssh/config
    chmod 600 ~/.ssh/config
  '';
}
