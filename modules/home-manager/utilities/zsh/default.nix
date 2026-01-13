{
  imports = [
    ./bat.nix      # A cat clone with syntax highlighting
    ./direnv.nix   # Per-directory environment variables
    ./eza.nix      # A modern replacement for ls
    ./fzf.nix      # Command-line fuzzy finder
    ./starship.nix # Customizable shell prompt
    ./zoxide.nix   # Smarter cd command
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
      update = "nix flake update --accept-flake-config --flake /home/ang3lo/nix-config";
      upgrade = "update && rebuild";
      
      ll = "eza -l";
      la = "eza -la";
      ls = "eza";
      cat = "bat";
      y = "yazi";
    };
  };
}
