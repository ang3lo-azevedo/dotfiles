{lib, ...}: {
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "gitlab.rnl.tecnico.ulisboa.pt" = {
        host = "gitlab.rnl.tecnico.ulisboa.pt";
        user = "git";
        identityFile = "~/.ssh/gitlab_ist";
      };

      "github-muskyboi" = {
        host = "github-muskyboi";
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/muskyboi";
      };

      "kitkat.serverhive.in" = {
        port = 5156;
        user = "nos4a2";
        identitiesOnly = true;
        identityFile = "~/.ssh/id_ed25519";
      };

      "sigma.ist.utl.pt" = {
        host = "sigma.ist.utl.pt sigma.tecnico.ulisboa.pt sigma02.ist.utl.pt";
        identitiesOnly = true;
        extraOptions = {
          PubkeyAuthentication = "no";
          PreferredAuthentications = "password";
        };
      };

      "eu.nixbuild.net" = {
        identityFile = "~/.ssh/my-nixbuild-key";
        extraOptions = {
          PubkeyAcceptedKeyTypes = "ssh-ed25519";
          ServerAliveInterval = "60";
          StrictHostKeyChecking = "accept-new";
        };
      };

      "gitlab-syssec.dpss.inesc-id.pt" = {
        host = "gitlab-syssec.dpss.inesc-id.pt 146.193.41.153";
        user = "git";
        identityFile = "~/.ssh/dpss-inesc";
      };

      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/key";
        identitiesOnly = true;
      };

      "homelab" = {
        host = "10.42.0.10 192.168.7.*";
        identitiesOnly = true;
        identityFile = "~/.ssh/id_ed25519";
      };

      "*" = {
        identitiesOnly = true;
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
