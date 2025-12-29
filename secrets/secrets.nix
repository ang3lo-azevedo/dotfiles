let
  yubikey = "age1yubikey1qgy9lcjxxsyl8z3daz34a4504v9fc2fv20w5784qwhlaz40chms7gjer68d";

  users = [ yubikey ];

  systems = [ ];

  usersAndSystems = users ++ systems;
in
{
  "root_password.age".publicKeys = usersAndSystems;
  "user_password.age".publicKeys = usersAndSystems;
}