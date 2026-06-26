{pkgs, ...}: {
  #imports = [./ffmpeg-encoder-plugin.nix];

  home.packages = [pkgs.davinci-resolve-studio];
}
