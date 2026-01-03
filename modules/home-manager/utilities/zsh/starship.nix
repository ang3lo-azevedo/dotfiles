{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      # Custom format: directory, git branch, git status, command duration, line break, prompt character
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
      
      package = {
        disabled = true; # Disable package version display
      };
      
      git_branch = {
        symbol = " ";
        format = "[$symbol$branch]($style) ";
      };
      
      git_commit = {
        tag_symbol = " ";
      };
      
      git_state = {
        format = "[\($state( $progress_current of $progress_total)\)]($style) ";
      };
      
      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
        # Text labels for git status
        conflicted = "conflicted ";
        ahead = "⇡\($count\) ";
        behind = "⇣\($count\) ";
        diverged = "⇕ ";
        up_to_date = "✓ ";
        untracked = "untracked ";
        stashed = "stashed ";
        modified = "modified ";
        staged = "staged ";
        renamed = "renamed ";
        deleted = "deleted ";
      };
      
      hostname = {
        ssh_only = true; # Only show hostname when connected via SSH
        format = "[$hostname](bold blue) ";
        disabled = false;
      };
      
      cmd_duration = {
        min_time = 10000; # Only show duration if command takes > 10s
        format = " took [$duration](bold yellow)";
      };
    };
  };
}
