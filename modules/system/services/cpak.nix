{inputs, ...}: {
  # The upstream module (rather than the nixpkgs package) also registers the
  # D-Bus system authority and polkit policy that `cpak system setup` expects
  imports = [inputs.cpak.nixosModules.default];

  services.cpak.enable = true;
}
