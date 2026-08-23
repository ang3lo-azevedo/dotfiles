{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    ffmpeg
  ];
}
