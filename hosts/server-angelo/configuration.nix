{
  imports = [
    ../../modules/system
    ../../modules/server-services/proxmox-ve.nix
  ];

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.t3lmo = {
    isNormalUser = true;
    description = "t3lmo";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
  };

  services.openssh.enable = true;

  programs.ssh.enableAskPassword = false;

  # Enable Docker Compose Stacks (for specialized apps)
  services.docker-compose-stacks.enable = true;
  services.docker-compose-stacks.dataDir = "/var/lib/docker-compose";

  # Disable container versions in favor of native implementations
  services.docker-compose-stacks.stacks = {
    redis.enable = false;      # Using native Redis instead
    vaultwarden.enable = false; # Using native Vaultwarden instead
    adguardhome.enable = false; # Using native AdGuard Home instead
    minecraft.enable = false;   # Using native Minecraft Server instead
    # Note: Nextcloud container disabled if using native, enable one or the other
    # nextcloud.enable = false;
  };

  # Enable native services
  services.redis-native.enable = true;

  services.vaultwarden-native = {
    enable = true;
    domain = "vault.example.com"; # Change this to your domain
  };

  services.adguardhome-native.enable = true;

  services.minecraft-server-native = {
    enable = true;
    maxPlayers = 20;
    motd = "Welcome to NixOS Minecraft!";
    difficulty = "normal";
  };

  # Optional: Enable native Nextcloud (comment out if using container version)
  # services.nextcloud-native = {
  #   enable = true;
  #   domain = "nextcloud.example.com";
  #   adminUser = "admin";
  #   adminPasswordFile = "/run/secrets/nextcloud_admin_password";
  # };

  # Ensure Podman/Docker is running
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  # Create persistent directories for data
  systemd.tmpfiles.rules = [
    "d /var/lib/docker-compose 0755 root root -"
    "d /var/lib/docker-compose/backups 0755 root root -"
  ];

  # Open firewall for services
  networking.firewall.allowedTCPPorts = [ 80 443 53 3000 25565 ];
  networking.firewall.allowedUDPPorts = [ 53 25565 ];
}
