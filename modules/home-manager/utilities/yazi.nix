{
  config,
  pkgs,
  ...
}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "yy";

    plugins = {
      mount = "${pkgs.yaziPlugins.mount}";
      bookmarks = "${pkgs.yaziPlugins.bookmarks}";
    };

    initLua = ''
      require("bookmarks"):setup({
        persist = "all",
        desc_format = "full",
        notify = {
          enable = true,
          timeout = 1,
          message = {
            new = "New bookmark '<key>' -> '<folder>'",
            delete = "Deleted bookmark in '<key>'",
            delete_all = "Deleted all bookmarks",
          },
        },
      })
    '';

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
      mgr.prepend_keymap = [
        {
          on = ["m"];
          run = "plugin bookmarks save";
          desc = "Save current position as a bookmark";
        }
        {
          on = ["'"];
          run = "plugin bookmarks jump";
          desc = "Jump to a bookmark";
        }
        {
          on = ["b" "d"];
          run = "plugin bookmarks delete";
          desc = "Delete a bookmark";
        }
        {
          on = ["b" "D"];
          run = "plugin bookmarks delete_all";
          desc = "Delete all bookmarks";
        }
        {
          on = ["M"];
          run = "plugin mount";
          desc = "Open mount manager";
        }
        {
          on = ["P"];
          run = "shell --confirm 'mount-android'";
          desc = "Mount and open Android phone";
        }
        {
          on = ["g" "p"];
          run = "cd ~/Documents/projects";
          desc = "Go to projects folder";
        }
        {
          on = ["g" "n"];
          run = "cd ~/nix-config";
          desc = "Go to nix-config";
        }
        {
          on = ["A"];
          run = "shell --confirm 'agy'";
          desc = "Open Antigravity in current folder";
        }
      ];
    };
  };

  home.packages = [
    pkgs.yazi
    (pkgs.writeShellScriptBin "mount-android" ''
      gio mount -li | awk -F= '{if(index($2,"mtp://") != 0) system("gio mount "$2)}'
      if ls -d /run/user/1000/gvfs/mtp* 1> /dev/null 2>&1; then
          ya emit cd "$(ls -d /run/user/1000/gvfs/mtp* | head -n 1)"
      fi
    '')
  ];

  xdg.mimeApps.defaultApplications = {
    "inode/directory" = ["yazi.desktop"];
  };

  xdg.configFile = {
    "xdg-desktop-portal-termfilechooser/yazi-wrapper.sh" = {
      executable = true;
      text = ''
        #!/bin/sh
        export PATH="$PATH:/run/current-system/sw/bin:/home/ang3lo/.nix-profile/bin:/etc/profiles/per-user/ang3lo/bin"
        multiple="$1"
        directory="$2"
        save="$3"
        path="$4"
        out="$5"

        if [ "$save" = "1" ]; then
            ghostty -e ${pkgs.yazi}/bin/yazi --chooser-file="$out" "$path"
        elif [ "$directory" = "1" ]; then
            ghostty -e ${pkgs.yazi}/bin/yazi --chooser-file="$out" --cwd-file="$out.1" "$path"
            if [ ! -s "$out" ] && [ -s "$out.1" ]; then
                cat "$out.1" > "$out"
            fi
            rm -f "$out.1"
        else
            ghostty -e ${pkgs.yazi}/bin/yazi --chooser-file="$out" "$path"
        fi
      '';
    };

    "xdg-desktop-portal-termfilechooser/config".text = ''
      [filechooser]
      cmd=${config.xdg.configHome}/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
    '';
  };
}
