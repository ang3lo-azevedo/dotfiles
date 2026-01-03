{
  imports = [
    ./bat.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./starship.nix
    ./zoxide.nix
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
    };

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
    };

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /home/ang3lo/nix-config";
      hmrebuild = "nix run home-manager -- switch --flake /home/ang3lo/nix-config#ang3lo";
      update = "nix flake update";
      
      ll = "ls -l";
      la = "ls -la";
      cat = "bat";
    };
  };
}
