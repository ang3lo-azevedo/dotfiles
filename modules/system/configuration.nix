{...}: {
  imports = [
    ./reduce-disk-usage.nix
    ./auto-upgrade.nix
  ];

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
  };

  services.openssh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.doCheckByDefault = false;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "ang3lo"
    ];
    # Use all cores for builds and allow multiple jobs in parallel.
    # max-jobs = "auto" allows local building for small things, but heavy builds will still be sent to remote builders (nixbuild).
    max-jobs = "auto";
    cores = 0;
    # Fetch substitutions in parallel while building.
    http-connections = 128;
    # cache.nixos.org often has HTTP/2 framing issues causing retries.
    http2 = false;
    # Use hard links in the store to save disk space during builds.
    keep-outputs = true;
  };

  # This value defines the first NixOS version this machine was installed on.
  # Do NOT change it after the initial install.
  system.stateVersion = "26.05";
}
