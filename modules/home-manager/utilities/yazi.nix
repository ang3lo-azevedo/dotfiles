{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "yy";

    plugins = {
      mount = pkgs.yaziPlugins.mount;
    };

    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
      };
    };

    keymap = {
      manager.prepend_keymap = [
        {
          on = ["M"];
          run = "plugin mount";
          desc = "Open mount manager";
        }
      ];
    };
  };

  xdg.mimeApps.defaultApplications = {
    "inode/directory" = ["yazi.desktop"];
  };
}
