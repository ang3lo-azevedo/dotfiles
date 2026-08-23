{lib}: let
  spaceId = lib.mkId "Cyber";
in {
  pins = lib.imap1 (i: v:
    v
    // {
      order = i;
      workspace = spaceId;
      id = lib.mkId (spaceId + v.name);
    }) [
    {
      name = "Google AI Studio";
      url = "https://aistudio.google.com/prompts/new_chat";
    }
  ];
}
