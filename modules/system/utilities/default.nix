{pkgs, ...}: {
  imports = [
    ./zsh.nix
    ./distrobox.nix
    ./gparted.nix
    ./wine.nix
  ];

  environment.systemPackages = with pkgs; [
    git
    gh
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    age
    ragenix
    age-plugin-yubikey
    yubikey-manager
    pcsclite
    pcsc-tools
    btop
    ntfs3g
  ];

  services = {
    gvfs.enable = true;
    udisks2.enable = true;

    # Nautilus D-Bus activates org.freedesktop.Tracker3.Miner.Files on startup; without
    # these services present it blocks on the activation timeout (~25s) every launch.
    gnome = {
      tinysparql.enable = true;
      localsearch.enable = true;
    };
  };
}
