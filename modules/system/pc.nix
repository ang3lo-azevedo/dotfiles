{
  config,
  pkgs,
  ...
}: {
  # Desktop-only NixOS modules — applied only to pc-angelo.
  imports = [
    ./dev
    ./display-manager
    ./gaming
    ./cyber
    ./services
    ./utilities
    ./secure-boot.nix
    #./impermanence.nix
    ./virtualization
    ./wayland.nix
    ./polkit_gnome.nix
    ./window-manager/nirinit.nix
  ];

  # Configure keymap in X11
  services = {
    xserver.xkb = {
      layout = "pt";
      variant = "";
    };

    # Enable PCSC daemon for smart card readers
    pcscd.enable = true;
  };

  # Configure console keymap and font for HiDPI screens (makes LUKS prompt readable)
  console = {
    keyMap = "pt-latin1";
    earlySetup = true;
    font = "ter-v32n";
    packages = with pkgs; [terminus_font];
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users = {
    mutableUsers = false;
    users = {
      ang3lo = {
        isNormalUser = true;
        description = "ang3lo";
        extraGroups = [
          "wheel"
          "networkmanager"
          "dialout"
          "i2c"
          "video"
          "render"
          "input"
        ];
        hashedPasswordFile = config.age.secrets.user_password.path;
      };
      root = {
        hashedPasswordFile = config.age.secrets.root_password.path;
      };
    };
  };

  # Enable firmware loading for all devices
  hardware.enableAllFirmware = true;

  # Allow dynamically linked, non-Nix binaries (e.g. IntelliJ Copilot agent) to run.
  programs.nix-ld.enable = true;

  # Enable Polkit
  security.polkit.enable = true;
}
