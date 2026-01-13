{
  imports = [
    ./bat.nix           # A cat clone with syntax highlighting
    ./direnv.nix        # Per-directory environment variables
    ./eza.nix           # A modern replacement for ls
    ./fzf.nix           # Command-line fuzzy finder
    ./shell-aliases.nix # Custom shell aliases
    ./starship.nix      # Customizable shell prompt
    ./zoxide.nix        # Smarter cd command
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
  };
}
