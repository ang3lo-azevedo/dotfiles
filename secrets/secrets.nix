let
  yubikey = "age1yubikey1qgy9lcjxxsyl8z3daz34a4504v9fc2fv20w5784qwhlaz40chms7gjer68d";
  test-vm = "age1j2yrgva9t5553jl0j2s766x48jna2jferhhfz0hkk0jmenm7n3aqgwd7sx";
in
{
  "root_password.age".publicKeys = [ yubikey test-vm ];
  "user_password.age".publicKeys = [ yubikey test-vm ];
}