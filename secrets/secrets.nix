let
  yubikey = "age1yubikey1qgy9lcjxxsyl8z3daz34a4504v9fc2fv20w5784qwhlaz40chms7gjer68d";
  test-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMbZ+K6BHi+CWPLTWvt9Hhu3ZZNouVffIfDOSEq5IOiw";
in
{
  "root_password.age".publicKeys = [ yubikey test-vm ];
  "user_password.age".publicKeys = [ yubikey test-vm ];
}