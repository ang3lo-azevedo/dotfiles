{
  programs.zsh.shellAliases = {
    # Tool related alises
    ll = "eza -l";
    la = "eza -la";
    ls = "eza";
    cat = "bat";
    y = "yazi";

    # NixOS related aliases
    rebuild = "sudo nixos-rebuild switch --flake /home/ang3lo/nix-config";
    hmrebuild = "home-manager switch --accept-flake-config --flake /home/ang3lo/nix-config#ang3lo";
    update = "nix flake update --accept-flake-config --flake /home/ang3lo/nix-config";
    upgrade = "update && rebuild";

  };
}