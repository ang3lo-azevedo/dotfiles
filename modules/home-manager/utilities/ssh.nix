{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "gitlab.rnl.tecnico.ulisboa.pt" = {
        host = "gitlab.rnl.tecnico.ulisboa.pt";
        user = "git";
        identityFile = "~/.ssh/gitlab_ist";
      };

      "github-muskyboi" = {
        host = "github.com";
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
        identityFile = "~/.ssh/gitlab_ist";
        identitiesOnly = true;
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
}
