{
  config,
  lib,
  ...
}: let
  colors = config.lib.stylix.colors;
in {
  programs.superfile = {
    enable = true;
    settings = {
      theme = "stylix";
      file_size_format = "binary";
      compress_icon = "󰈑";
      compress_extensions = ["tar" "gz" "tgz" "bz2" "tbz2" "xz" "txz" "lz" "lzma" "tlz" "zst" "tzst" "7z" "zip" "rar" "rpm" "deb" "apk" "cab" "ar" "cpio" "iso" "dmg" "vhd" "vdi" "qcow2" "ova"];
      show_file_size = true;
      show_folder_size = true;
      show_hidden = true;
      editor = "antigravity-ide";
      metadata = true;
    };
  };

  xdg = {
    configFile."superfile/theme/stylix.toml".text = ''
      code_syntax_highlight = "monokai"

      full_screen_fg = "#${colors.base05}"
      full_screen_bg = "#${colors.base00}"

      gradient_color = ["#${colors.base0D}", "#${colors.base0E}"]
      directory_icon_color = ""

      file_panel_fg = "#${colors.base05}"
      file_panel_bg = "#${colors.base00}"
      file_panel_border = "#${colors.base03}"
      file_panel_border_active = "#${colors.base0D}"
      file_panel_top_directory_icon = "#${colors.base0A}"
      file_panel_top_path = "#${colors.base0D}"
      file_panel_item_selected_fg = "#${colors.base0B}"
      file_panel_item_selected_bg = "#${colors.base01}"

      footer_fg = "#${colors.base05}"
      footer_bg = "#${colors.base00}"
      footer_border = "#${colors.base03}"
      footer_border_active = "#${colors.base0D}"

      sidebar_fg = "#${colors.base05}"
      sidebar_bg = "#${colors.base00}"
      sidebar_title = "#${colors.base08}"
      sidebar_border = "#${colors.base00}"
      sidebar_border_active = "#${colors.base0D}"
      sidebar_item_selected_fg = "#${colors.base0B}"
      sidebar_item_selected_bg = "#${colors.base01}"
      sidebar_divider = "#${colors.base03}"

      modal_fg = "#${colors.base05}"
      modal_bg = "#${colors.base01}"
      modal_border_active = "#${colors.base0D}"
      modal_cancel_fg = "#${colors.base05}"
      modal_cancel_bg = "#${colors.base03}"
      modal_confirm_fg = "#${colors.base00}"
      modal_confirm_bg = "#${colors.base0B}"

      help_menu_hotkey = "#${colors.base0D}"
      help_menu_title = "#${colors.base08}"

      cursor = "#${colors.base05}"
      correct = "#${colors.base0B}"
      error = "#${colors.base08}"
      hint = "#${colors.base0C}"
      cancel = "#${colors.base03}"
    '';

    desktopEntries.superfile = {
      name = "Superfile";
      genericName = "File Manager";
      exec = "ghostty -e superfile %u";
      terminal = false;
      categories = [
        "FileManager"
        "Utility"
      ];
      mimeType = ["inode/directory"];
    };

    mimeApps.defaultApplications = {
      "inode/directory" = lib.mkForce ["superfile.desktop"];
    };

    configFile."xdg-desktop-portal-termfilechooser/config".text = ''
      [filechooser]
      cmd=ghostty -e superfile --chooser-file %s
    '';
  };
}
