{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "yy";

    plugins = {
      mount =
        pkgs.fetchFromGitHub {
          owner = "yazi-rs";
          repo = "plugins";
          rev = "main";
          sha256 = "1g98jbl52jgwl389rfzj15q7ikm4njblwaf9bd5dq3kw1v6fw65r";
        }
        + "/mount.yazi";
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
