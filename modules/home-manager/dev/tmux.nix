{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    terminal = "tmux-256color";
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    clock24 = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank # Syncs tmux copy mode to system clipboard with wl-copy/xclip/OSC 52
      resurrect
    ];

    extraConfig = ''
      # 24-bit truecolor (RGB) support
      set -as terminal-features ",*:RGB"
      set -as terminal-overrides ",*:Tc"

      # Enable OSC 52 clipboard pass-through to outer terminal
      set -s set-clipboard on

      # Vi mode copy/paste keybindings with system clipboard integration
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "wl-copy"

      # Split panes using | and - in current working directory
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Reload tmux configuration with prefix + r
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded!"
    '';
  };
}
