{
  mkId = seed:
    let
      hash = builtins.hashString "sha256" seed;
      s = builtins.substring;
    in
      "${s 0 8 hash}-${s 8 4 hash}-${s 12 4 hash}-${s 16 4 hash}-${s 20 12 hash}";
}
