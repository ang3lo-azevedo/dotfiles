{pkgs, ...}: {
  home.packages = [
    pkgs.davinci-resolve-personal
  ];

  home.file = pkgs.davinci-resolve-personal.homeFiles or {};
}
