{ config, ... }:
let
  # Dynamically pull the secret path if Home Manager is running as a NixOS module,
  # otherwise fallback to the default Agenix path for standalone Home Manager.
  keyfile = 
    if config ? osConfig then config.osConfig.age.secrets.nvchecker_keyfile.path
    else "/run/agenix/nvchecker_keyfile";
in
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
    nvfetcher = "nix run nixpkgs#nvfetcher -- -c /home/ang3lo/nix-config/pkgs/nvfetcher.toml -o /home/ang3lo/nix-config/pkgs/_sources $([ -f ${keyfile} ] && echo \"-k ${keyfile}\")";
    update = "nvfetcher && nix flake update --accept-flake-config --flake /home/ang3lo/nix-config";

    # Fast day-to-day system apply: no lockfile bump, better progress output.
    upgrade = "update && rebuild";
  };
}