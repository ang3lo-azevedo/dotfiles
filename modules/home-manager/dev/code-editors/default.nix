{pkgs, ...}: {
  imports = [
    # ./vscode
    ./antigravity
    ./intellij-idea.nix
    ./opencode.nix
    ./claude-code.nix
    ./cursor
  ];

  # Electron IDEs inherit systemd's NoNewPrivileges restriction, which blocks sudo
  # inside the integrated terminal. systemd-run --scope spawns a new transient scope
  # outside the IDE's cgroup, lifting the restriction for that shell only.
  home.file.".local/bin/ide-zsh-wrapper" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      # Wrapper script to launch zsh without the "no new privileges" flag
      # Uses systemd-run to create a new process scope

      if command -v systemd-run >/dev/null 2>&1; then
        # Use systemd-run to launch in a new scope (bypasses no new privileges flag)
        exec systemd-run --user --scope --quiet ${pkgs.zsh}/bin/zsh "$@"
      else
        # Fallback: try to use setsid to create a new session
        exec ${pkgs.util-linux}/bin/setsid ${pkgs.zsh}/bin/zsh "$@"
      fi
    '';
  };
}
