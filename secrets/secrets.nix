let
  yubikey = "age1yubikey1qgy9lcjxxsyl8z3daz34a4504v9fc2fv20w5784qwhlaz40chms7gjer68d";

  pc-angelo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJKo5FTbsC2Ey5qaRfKkTjrn4S5MRTNjxqzy7ZPObS/F";

  users = [ yubikey ];

  systems = [ pc-angelo ];

  usersAndSystems = users ++ systems;
in
{
  "root_password.age".publicKeys = usersAndSystems;
  "user_password.age".publicKeys = usersAndSystems;
  "wifi-ssid.age".publicKeys = usersAndSystems;
  "wifi-password.age".publicKeys = usersAndSystems;
}
