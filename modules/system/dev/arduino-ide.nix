{
  pkgs,
  lib,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    arduino-ide
  ];

  users.groups.dialout.members =
    lib.mapAttrsToList (name: _: name)
    (lib.filterAttrs (_: user: user.isNormalUser) config.users.users);
}
