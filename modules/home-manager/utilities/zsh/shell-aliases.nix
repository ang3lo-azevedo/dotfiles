{
  programs.zsh.shellAliases = {
    
    # Tool related alises
    ll = "eza -l";
    la = "eza -la";
    ls = "eza";
    cat = "bat";
    y = "yazi";

    # NixOS related aliases
    rebuild = "sudo nixos-rebuild switch --accept-flake-config --flake path:/home/ang3lo/nix-config#pc-angelo -L";
    hmrebuild = "home-manager switch --accept-flake-config --flake path:/home/ang3lo/nix-config#ang3lo";
    update = "nix flake update --accept-flake-config --flake /home/ang3lo/nix-config";

    # Fast day-to-day system apply: no lockfile bump, better progress output.
    upgrade = "rebuild";

    # Full channel update + rebuild when you explicitly want new inputs.
    full-upgrade = "update && rebuild";

  };
}