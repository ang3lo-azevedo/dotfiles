{lib}: let
  spaceId = lib.mkId "Cyber";
  aiId = lib.mkId (spaceId + "AI");
in {
  pins = [
    {
      name = "Google AI Studio";
      id = lib.mkId (spaceId + "Google AI Studio");
      url = "https://aistudio.google.com/prompts/new_chat";
      workspace = spaceId;
      folderParentId = aiId;
      order = 1;
    }
  ];
}
