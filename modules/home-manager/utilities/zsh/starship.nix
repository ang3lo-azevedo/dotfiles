{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      package = {
        disabled = true;
      };
      git_branch = {
        symbol = "🌱 ";
      };
      git_commit = {
        tag_symbol = "🔖 ";
      };
      git_state = {
        format = "[\($state( $progress_current of $progress_total)\)]($style) ";
      };
      git_status = {
        conflicted = "🏳";
        ahead = "🏎💨";
        behind = "😰";
        diverged = "😵";
        up_to_date = "✓";
        untracked = "🤷";
        stashed = "📦";
        modified = "📝";
        staged = "[++\($count\)](green)";
        renamed = "👅";
        deleted = "🗑";
      };
      hostname = {
        ssh_only = false;
        format = "[$hostname](bold blue) ";
        disabled = false;
      };
    };
  };
}
