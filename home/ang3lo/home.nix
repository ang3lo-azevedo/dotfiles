{inputs, ...}: {
  home = {
    username = "ang3lo";
    homeDirectory = "/home/ang3lo";
    stateVersion = "26.05";
    sessionVariables = {
      EDITOR = "antigravity-ide";
      BROWSER = "zen-browser";
      TERMINAL = "ghostty";
      EXPLORER = "$TERMINAL -e yazi";
      MUSIC_PLAYER = "spotify";
      DISCORD = "equibop";
      YOUTUBE_PLAYER = "grayjay";
    };
  };

  imports = [
    inputs.stylix.homeModules.stylix
    inputs.binaryninja.hmModules.binaryninja
    "${inputs.self}/modules/home-manager"
  ];

  programs.home-manager.enable = true;

  # Avoid warning when using home-manager.useGlobalPkgs, since NixOS already applies the stylix overlays to the global pkgs.
  stylix.overlays.enable = false;

  # Silence the evaluation warning caused by `binaryninja` injecting its overlay into HM.
  # Since useGlobalPkgs is true, this overlay is ignored by HM anyway, and it's already
  # applied globally in flake.nix. Forcing it to empty prevents the warning.
  nixpkgs.overlays = inputs.nixpkgs.lib.mkForce [];
}
