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
    nvfetcher = "nix run nixpkgs#nvfetcher -- -c /home/ang3lo/nix-config/pkgs/nvfetcher.toml -o /home/ang3lo/nix-config/pkgs/_sources -k /run/secrets/nvchecker_keyfile";
    update = "nvfetcher && nix flake update --accept-flake-config --flake /home/ang3lo/nix-config";

    # Fast day-to-day system apply: no lockfile bump, better progress output.
    upgrade = "update && rebuild";
  };
}