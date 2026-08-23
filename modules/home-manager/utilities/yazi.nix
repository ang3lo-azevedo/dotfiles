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
      mgr.prepend_keymap = [
        {
          on = ["M"];
          run = "plugin mount";
          desc = "Open mount manager";
        }
      ];
    };
  };

  home.packages = [pkgs.yazi];

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
