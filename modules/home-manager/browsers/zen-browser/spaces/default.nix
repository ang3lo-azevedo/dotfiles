{ lib }:
let
  findNixFiles = dir:
    let
      files = builtins.readDir dir;
      process = name: type:
        let
          path = dir + "/${name}";
        in
          if type == "directory" then
            findNixFiles path
          else if type == "regular" && lib.hasSuffix ".nix" name then
            [ path ]
          else
            [];
    in
      lib.flatten (lib.mapAttrsToList process files);

  allFiles = findNixFiles ./.;
  configFiles = builtins.filter (p: p != ./default.nix) allFiles;

  configs = map (f: removeAttrs (import f) ["imports"]) configFiles;

  allPins = builtins.concatLists (map (c: c.pins or []) configs);
  allSpaces = builtins.concatLists (map (c: c.spaces or []) configs);
  allContainers = builtins.concatLists (map (c: c.containers or []) configs);

  processItems = items: startPos:
    lib.listToAttrs (lib.imap1 (i: item: {
      name = item.name;
      value = removeAttrs item ["name"] // {
        position = startPos + i;
      };
    }) items);

  processContainers = items:
    lib.listToAttrs (map (item: {
      name = item.name;
      value = removeAttrs item ["name"];
    }) items);

in
{
  #pinsForce = true;
  spacesForce = true;
  containersForce = true;
  pins = processItems allPins 100;
  spaces = processItems allSpaces 1000;
  containers = processContainers allContainers;
}
