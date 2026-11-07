{
  # Automatically optimise the Nix store to reduce disk usage
  nix = {
    optimise = {
      automatic = true;

      # Optional, allows customizing optimisation schedule
      dates = [
        "03:45"
      ];
    };

    # 3d retention: rebuilds happen many times a day, so a week of generations
    # piles up large closures (kernel, emulator AppImages, Steam) and dominates
    # the store. Three days still leaves a rollback window across a few days of
    # work while reclaiming far more space.
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };

    # Deduplicates identical files in the store with hard links after each build.
    # nix-store --optimise can be run manually for a one-off pass.
    settings = {
      auto-optimise-store = true;
    };
  };

  # Cap the systemd journal: it is otherwise uncapped and had grown to ~2G.
  # 200M keeps enough recent logs to debug a boot or service failure.
  services.journald.settings.Journal.SystemMaxUse = "200M";
}
