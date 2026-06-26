{pkgs, ...}: {
  home.file.".local/share/DaVinciResolve/IOPlugins/ffmpeg_encoder_plugin.dvcp.bundle".source = "${pkgs.ffmpeg-encoder-plugin-resolve}/ffmpeg_encoder_plugin.dvcp.bundle";
}
