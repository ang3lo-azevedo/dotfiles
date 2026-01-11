{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./distrobox.nix
    ./lact.nix
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
  ];

  services.gvfs.enable = true;
  services.udisks2.enable = true;
}
