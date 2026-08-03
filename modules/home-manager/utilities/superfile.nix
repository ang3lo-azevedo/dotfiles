{pkgs, ...}: {
  home.packages = [pkgs.superfile];

  xdg.configFile."superfile/config.toml".text = ''
    theme = "gruvbox"
    file_size_format = "binary"
    compress_icon = "\u{f0216}"
    compress_extensions = ["tar", "gz", "tgz", "bz2", "tbz2", "xz", "txz", "lz", "lzma", "tlz", "zst", "tzst", "7z", "zip", "rar", "rpm", "deb", "apk", "cab", "ar", "cpio", "iso", "dmg", "vhd", "vdi", "qcow2", "ova"]
    default_sort_type = "DirFirst"
    show_file_size = true
    show_folder_size = true
    show_hidden = true
    editor = "antigravity-ide"
    metadata = [
      { regex = "\.(mp4|mkv|avi|mov|webm|flv|wmv)$", color = "blue" }
      { regex = "\.(mp3|flac|wav|ogg|aac|m4a|wma|opus)$", color = "cyan" }
      { regex = "\.(png|jpg|jpeg|gif|bmp|svg|webp|tiff|ico)$", color = "magenta" }
      { regex = "\.(pdf|doc|docx|xls|xlsx|ppt|pptx|odt|ods|odp)$", color = "yellow" }
      { regex = "\.(zip|tar|gz|tgz|bz2|tbz2|xz|txz|lz|lzma|tlz|zst|tzst|7z|rar)$", color = "red" }
    ]
  '';
}
