{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "niri-session-manager";
  version = "unstable-2024-11-20";

  src = fetchFromGitHub {
    owner = "MTeaHead";
    repo = "niri-session-manager";
    rev = "2d9ae35bb654ad0cdc5f646e5fee446bf3af083c";
    hash = "sha256-5itrK5V9ZHGKIjKODTcneAanvs021Bk0CBJxBYRPaMs=";
  };

  cargoHash = "sha256-79ynRnPJ1i+qRYJIa9Wmb6qKUbO2rDnLp7WcunX7y5U=";

  meta = with lib;
    {
      description = "A session manager for Niri window manager";
      homepage = "https://github.com/MTeaHead/niri-session-manager";
      license = licenses.mit;
      platforms = platforms.linux;
      mainProgram = "niri-session-manager";
    };
}
