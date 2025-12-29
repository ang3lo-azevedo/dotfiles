let
  yubikey = "age1yubikey1qgy9lcjxxsyl8z3daz34a4504v9fc2fv20w5784qwhlaz40chms7gjer68d";

  pc-angelo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPHITd9574ykchPZZUfm/wvC5E2aF1Ay3pBIyXrEar8Q";

  users = [ yubikey ];

  systems = [ pc-angelo ];

  usersAndSystems = users ++ systems;
in
{
  "root_password.age".publicKeys = usersAndSystems;
  "user_password.age".publicKeys = usersAndSystems;
}