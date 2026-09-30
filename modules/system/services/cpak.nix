{
  inputs,
  pkgs,
  ...
}: {
  # The upstream module (rather than the nixpkgs package) also registers the
  # D-Bus system authority and polkit policy that `cpak system setup` expects
  imports = [inputs.cpak.nixosModules.default];

  services.cpak.enable = true;

  # Apps with displayX11 get a private Xwayland per sandbox, looked up on PATH;
  # niri only ships xwayland-satellite, which cpak can't use
  environment.systemPackages = [pkgs.xwayland];
}
