{pkgs, ...}: {
  programs.steam = {
    enable = true;

    gamescopeSession.enable = true;

    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;

    protontricks.enable = true;

    # Applies nix-gaming kernel parameters and other SteamOS-like tweaks for better performance
    platformOptimizations.enable = true;
  };

  programs.steam.extraCompatPackages = with pkgs; [
    # CachyOS Proton build, x86_64-v3 optimized (requires a CPU that supports AVX2)
    proton-cachyos_x86_64_v3
    proton-ge-bin
  ];
}
