{lib}: let
  spaceId = lib.mkId "Space";
  folderId = lib.mkId (spaceId + "One Pace");
in {
  pins = lib.imap1 (i: v:
    v
    // {
      order = i;
      workspace = folderId;
      id = lib.mkId (folderId + v.name);
    }) [
    {
      name = "One Pace";
      url = "https://web.stremio.com/#/detail/series/onepace/JA_1";
    }
    {
      name = "One Pace Viewing Guide";
      url = "https://gist.github.com/ang3lo-azevedo/0e50cdc0954347854919aa9df24fbf6b";
    }
    {
      name = "Tracker";
      url = "https://docs.google.com/spreadsheets/d/1HQRMJgu_zArp-sLnvFMDzOyjdsht87eFLECxMK858lA";
    }
    {
      name = "Series Graph";
      url = "https://seriesgraph.com/show/37854-one-piece";
    }
    {
      name = "Notes";
      url = "https://docs.google.com/document/d/1AFoXhRCAep72wqFVLfncBRupF5U4eJ1J0-5-_GvnKJI/edit?tab=t.0";
    }
    {
      name = "One Piece GPT";
      url = "https://chatgpt.com/g/g-MU47GkPiw-one-piece-gpt";
    }
    {
      name = "Sheet 2";
      url = "https://docs.google.com/spreadsheets/d/1LYxp1i5FldNiKdL8BKaQ3T8EeueCSpgDWvN51kCBcKI";
    }
    {
      name = "Sheet 3";
      url = "https://docs.google.com/spreadsheets/d/1JK_9kJbC1E_eOI60eMUIZQpNSs3XgVeiOkhkFZAW6AI";
    }
    {
      name = "Drive";
      url = "https://drive.google.com/drive/folders/1D26fyrWtWDh5jtmbhrejXIHIrNZdVz1P";
    }
  ];
}
