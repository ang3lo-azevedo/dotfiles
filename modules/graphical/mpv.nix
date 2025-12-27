{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    
    # Scripts will be installed from your repository
    # You'll need to clone your mpv repo and link the scripts manually
    # or use home.file to symlink them
    
    config = {
      # Video settings
      profile = "gpu-hq";
      vo = "gpu";
      hwdec = "auto-safe";
      gpu-context = "wayland";
      
      # Quality settings
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      dscale = "mitchell";
      
      # Audio settings
      audio-file-auto = "fuzzy";
      audio-pitch-correction = "yes";
      volume = 100;
      volume-max = 200;
      
      # Subtitle settings
      sub-auto = "fuzzy";
      sub-file-paths = "subs:subtitles";
      slang = "pt,por,en,eng";
      alang = "pt,por,en,eng";
      
      # UI settings
      osd-bar = "yes";
      osd-font-size = 32;
      osd-color = "#FFFFFF";
      osd-border-color = "#000000";
      osd-border-size = 2;
      osd-duration = 2000;
      
      # Screenshot settings
      screenshot-format = "png";
      screenshot-png-compression = 8;
      screenshot-template = "%F-%wH.%wM.%wS.%wT";
      screenshot-directory = "~/Pictures/mpv-screenshots";
      
      # Performance
      cache = "yes";
      demuxer-max-bytes = "512M";
      demuxer-max-back-bytes = "128M";
      
      # Misc
      keep-open = "yes";
      save-position-on-quit = "yes";
      watch-later-directory = "~/.cache/mpv/watch_later";
      
      # IPC for scripts
      input-ipc-server = "/tmp/mpvsocket";
    };
    
    bindings = {
      # Playback
      "SPACE" = "cycle pause";
      "." = "frame-step";
      "," = "frame-back-step";
      
      # Seeking
      "RIGHT" = "seek  5";
      "LEFT" = "seek -5";
      "UP" = "seek  60";
      "DOWN" = "seek -60";
      "Shift+RIGHT" = "seek  30";
      "Shift+LEFT" = "seek -30";
      
      # Volume
      "9" = "add volume -2";
      "0" = "add volume 2";
      "/" = "add volume -5";
      "*" = "add volume 5";
      "m" = "cycle mute";
      
      # Subtitles
      "v" = "cycle sub-visibility";
      "j" = "cycle sub";
      "J" = "cycle sub down";
      "z" = "add sub-delay -0.1";
      "x" = "add sub-delay +0.1";
      "Z" = "add sub-scale -0.1";
      "X" = "add sub-scale +0.1";
      
      # Audio
      "#" = "cycle audio";
      
      # Video
      "1" = "add contrast -1";
      "2" = "add contrast 1";
      "3" = "add brightness -1";
      "4" = "add brightness 1";
      "5" = "add gamma -1";
      "6" = "add gamma 1";
      "7" = "add saturation -1";
      "8" = "add saturation 1";
      
      # Window
      "f" = "cycle fullscreen";
      "T" = "cycle ontop";
      
      # Playlist
      ">" = "playlist-next";
      "<" = "playlist-prev";
      "ENTER" = "playlist-next force";
      
      # Screenshots
      "s" = "screenshot";
      "S" = "screenshot video";
      "Ctrl+s" = "screenshot window";
      "Alt+s" = "screenshot each-frame";
      
      # Speed
      "[" = "multiply speed 1/1.1";
      "]" = "multiply speed 1.1";
      "{" = "multiply speed 0.5";
      "}" = "multiply speed 2.0";
      "BS" = "set speed 1.0";
      
      # Quit
      "q" = "quit";
      "Q" = "quit-watch-later";
      "ESC" = "set fullscreen no";
    };
    
    profiles = {
      "high-quality" = {
        profile-desc = "High quality rendering";
        scale = "ewa_lanczossharp";
        cscale = "ewa_lanczossharp";
        dscale = "mitchell";
        dither-depth = "auto";
        correct-downscaling = "yes";
        sigmoid-upscaling = "yes";
        deband = "yes";
      };
      
      "low-latency" = {
        profile-desc = "Low latency for gaming/live streams";
        video-sync = "audio";
        interpolation = "no";
        cache = "no";
      };
    };
  };
  
  # Create screenshot directory
  home.file.".config/mpv/.keep".text = "";
  
  # Note: To use your custom scripts from https://github.com/ang3lo-azevedo/mpv
  # Clone the repo and symlink the scripts folder:
  # ln -s /path/to/your/mpv-repo/scripts ~/.config/mpv/scripts
  # ln -s /path/to/your/mpv-repo/shaders ~/.config/mpv/shaders
}