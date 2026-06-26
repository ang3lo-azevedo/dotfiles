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

    # 7d retention keeps one week of rollback generations; shorter risks losing
    # a working config before a problem is noticed, longer wastes significant space.
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    # Deduplicates identical files in the store with hard links after each build.
    # nix-store --optimise can be run manually for a one-off pass.
    settings = {
      auto-optimise-store = true;
    };
  };
}
