{config, ...}: {
  programs.ssh.extraConfig = ''
    Host eu.nixbuild.net
      PubkeyAcceptedKeyTypes ssh-ed25519
      ServerAliveInterval 60
      IdentityFile ${config.age.secrets.nixbuild_key.path}
  '';

  programs.ssh.knownHosts = {
    nixbuild = {
      hostNames = ["eu.nixbuild.net"];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
    };
  };

  # Disabled: nixbuild.net fails otherwise-successful builds when its cachix
  # upload fails, and the account shell is locked (run:write denied) so
  # ignore-cache-failures cannot be set. Re-enable once nixbuild support
  # restores shell access or the cache push failures stop.
  # nix.distributedBuilds = true;
  # nix.buildMachines = [
  #   {
  #     hostName = "eu.nixbuild.net";
  #     system = "x86_64-linux";
  #     maxJobs = 100;
  #     supportedFeatures = ["benchmark" "big-parallel"];
  #   }
  # ];
}
