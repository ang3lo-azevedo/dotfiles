{
  programs.ghostty = {
    enable = true;
    settings = {
      window-decoration = "none";
      window-padding-y = "12,12";
      window-padding-x = "12,12";
      window-padding-balance = true;
      command = "TERM=xterm-256color /usr/bin/bash";
    };
  };
}
