{
  mkId = seed: let
    hash = builtins.hashString "sha256" seed;
    s = builtins.substring;
  in "${s 0 8 hash}-${s 8 4 hash}-${s 12 4 hash}-${s 16 4 hash}-${s 20 12 hash}";

  blackTheme = {
    colors = [
      {
        red = 0;
        green = 0;
        blue = 0;
        algorithm = "floating";
        lightness = 3;
        position.x = 180;
        position.y = 175;
      }
    ];
    opacity = 1.0;
    texture = 0.0;
  };
}
