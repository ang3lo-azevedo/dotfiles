{lib}: let
  spaceId = lib.mkId "Space";
  folderId = lib.mkId (spaceId + "One Pace");
in {
  pins = [
    {
      name = "One Pace";
      id = lib.mkId (spaceId + "One Pace Stremio");
      url = "https://web.stremio.com/#/detail/series/onepace/JA_1";
      workspace = spaceId;
      folderParentId = folderId;
      order = 1;
    }
    {
      name = "Subtitle Guide";
      id = lib.mkId (spaceId + "One Pace Subtitle Guide");
      url = "https://gist.github.com/ang3lo-azevedo/0e50cdc0954347854919aa9df24fbf6b";
      workspace = spaceId;
      folderParentId = folderId;
      order = 2;
    }
    {
      name = "Tracker";
      id = lib.mkId (spaceId + "One Pace Tracker");
      url = "https://docs.google.com/spreadsheets/d/1HQRMJgu_zArp-sLnvFMDzOyjdsht87eFLECxMK858lA";
      workspace = spaceId;
      folderParentId = folderId;
      order = 3;
    }
    {
      name = "Series Graph";
      id = lib.mkId (spaceId + "One Pace Series Graph");
      url = "https://seriesgraph.com/show/37854-one-piece";
      workspace = spaceId;
      folderParentId = folderId;
      order = 4;
    }
    {
      name = "Notes";
      id = lib.mkId (spaceId + "One Pace Notes");
      url = "https://docs.google.com/document/d/1AFoXhRCAep72wqFVLfncBRupF5U4eJ1J0-5-_GvnKJI/edit?tab=t.0";
      workspace = spaceId;
      folderParentId = folderId;
      order = 5;
    }
    {
      name = "One Piece GPT";
      id = lib.mkId (spaceId + "One Pace GPT");
      url = "https://chatgpt.com/g/g-MU47GkPiw-one-piece-gpt";
      workspace = spaceId;
      folderParentId = folderId;
      order = 6;
    }
    {
      name = "Sheet 2";
      id = lib.mkId (spaceId + "One Pace Sheet 2");
      url = "https://docs.google.com/spreadsheets/d/1LYxp1i5FldNiKdL8BKaQ3T8EeueCSpgDWvN51kCBcKI";
      workspace = spaceId;
      folderParentId = folderId;
      order = 7;
    }
    {
      name = "Sheet 3";
      id = lib.mkId (spaceId + "One Pace Sheet 3");
      url = "https://docs.google.com/spreadsheets/d/1JK_9kJbC1E_eOI60eMUIZQpNSs3XgVeiOkhkFZAW6AI";
      workspace = spaceId;
      folderParentId = folderId;
      order = 8;
    }
    {
      name = "Drive";
      id = lib.mkId (spaceId + "One Pace Drive");
      url = "https://drive.google.com/drive/folders/1D26fyrWtWDh5jtmbhrejXIHIrNZdVz1P";
      workspace = spaceId;
      folderParentId = folderId;
      order = 9;
    }
  ];
}
