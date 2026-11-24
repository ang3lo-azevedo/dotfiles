{
  imports = [
    ./bat.nix # A cat clone with syntax highlighting
    ./direnv.nix # Per-directory environment variables
    ./eza.nix # A modern replacement for ls
    ./fzf.nix # Command-line fuzzy finder
    ./ripgrep.nix # Fast recursive grep
    ./shell-aliases.nix # Custom shell aliases
    ./starship.nix # Customizable shell prompt
    ./tealdeer.nix # tldr pages: short command examples
    ./zoxide.nix # Smarter cd command
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
    };

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
    };

    initContent = ''
      # Load Gemini API age secrets if available
      for p in /run/agenix /run/secrets; do
        if [[ -z "$GOOGLE_GEMINI_BASE_URL" && -f "$p/gemini_base_url" ]]; then
          export GOOGLE_GEMINI_BASE_URL="$(< "$p/gemini_base_url")"
        fi
        if [[ -z "$GEMINI_API_KEY" && -f "$p/gemini_api_key" ]]; then
          export GEMINI_API_KEY="$(< "$p/gemini_api_key")"
          export OPENAI_API_KEY="$GEMINI_API_KEY"
        fi
      done
    '';
  };
}
