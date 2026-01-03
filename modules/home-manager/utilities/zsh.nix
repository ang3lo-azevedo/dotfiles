{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /home/ang3lo/nix-config";
    };
  };
}
