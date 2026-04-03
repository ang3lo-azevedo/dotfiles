{ pkgs, ... }:
{
  virtualisation = {
    #docker.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  # Ensure podman compose has a provider available system-wide.
  environment.systemPackages = with pkgs; [
    podman-compose
  ];

  environment.variables.PODMAN_COMPOSE_PROVIDER = "${pkgs.podman-compose}/bin/podman-compose";
}
