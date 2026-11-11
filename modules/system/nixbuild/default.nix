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

  nix = {
    # Relies on the account setting ignore-cache-failures=true: without it
    # nixbuild.net fails otherwise-successful builds when its cachix upload fails.
    distributedBuilds = true;

    # When a build is dispatched to eu.nixbuild.net, let the remote fetch that build's
    # inputs from binary caches itself instead of uploading them over this machine's
    # slow uplink. Cuts upload traffic on every rebuild, not just for local-pinned
    # packages: only uncached paths (locally built or vendor FODs) still get copied up.
    settings.builders-use-substitutes = true;

    buildMachines = [
      {
        hostName = "eu.nixbuild.net";
        system = "x86_64-linux";
        maxJobs = 16;
        speedFactor = 1;
        supportedFeatures = [
          "benchmark"
          "big-parallel"
        ];
      }
    ];
  };
}
