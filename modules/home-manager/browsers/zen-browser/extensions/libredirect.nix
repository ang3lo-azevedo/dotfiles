{
  pkgs,
  lib,
  profileName,
  ...
}: let
  settings = {
    options = {
      # ---- active redirects ----
      reddit = {
        enabled = true;
        frontend = "redlib";
        unsupportedUrls = "bypass";
        instance = "public";
        redirectOnlyInIncognito = false;
        redirectType = "main_frame";
      };
      redlib = [
        "https://rl.bloat.cat"
        "https://redlib.privadency.com"
        "https://redlib.pi.at.eu.org"
      ];

      # ---- inactive (defaults kept for clean first-run state) ----
      youtube = {
        enabled = false;
        redirectType = "main_frame";
        frontend = "invidious";
        embedFrontend = "invidious";
        unsupportedUrls = "bypass";
        redirectOnlyInIncognito = false;
      };
      youtubeMusic = {
        enabled = false;
        frontend = "hyperpipe";
        unsupportedUrls = "bypass";
        redirectOnlyInIncognito = false;
      };
      twitter = {
        enabled = false;
        redirectType = "main_frame";
        unsupportedUrls = "bypass";
        frontend = "nitter";
        instance = "public";
        redirectOnlyInIncognito = false;
      };
      chatGpt = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "duckDuckGoAiChat";
        redirectOnlyInIncognito = false;
      };
      bluesky = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "skyview";
        redirectOnlyInIncognito = false;
      };
      tumblr = {
        enabled = false;
        redirectType = "main_frame";
        unsupportedUrls = "bypass";
        frontend = "priviblur";
        instance = "public";
        redirectOnlyInIncognito = false;
      };
      twitch = {
        enabled = false;
        redirectType = "main_frame";
        unsupportedUrls = "bypass";
        frontend = "safetwitch";
        instance = "public";
        redirectOnlyInIncognito = false;
      };
      tiktok = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "proxiTok";
        instance = "public";
        redirectOnlyInIncognito = false;
      };
      instagram = {
        enabled = false;
        frontend = "kittygram";
        embedFrontend = "kittygram";
        unsupportedUrls = "bypass";
        instance = "public";
        redirectOnlyInIncognito = false;
      };
      imdb = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "libremdb";
        instance = "public";
        redirectOnlyInIncognito = false;
      };
      bilibili = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "mikuInvidious";
        redirectOnlyInIncognito = false;
      };
      pixiv = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "pixivFe";
        redirectOnlyInIncognito = false;
      };
      fandom = {
        enabled = false;
        unsupportedUrls = "bypass";
        instance = "public";
        frontend = "breezeWiki";
        redirectOnlyInIncognito = false;
      };
      imgur = {
        enabled = false;
        redirectType = "main_frame";
        unsupportedUrls = "bypass";
        frontend = "rimgo";
        instance = "public";
        redirectOnlyInIncognito = false;
      };
      pinterest = {
        enabled = false;
        unsupportedUrls = "bypass";
        redirectType = "main_frame";
        frontend = "binternet";
        redirectOnlyInIncognito = false;
      };
      soundcloud = {
        enabled = false;
        redirectType = "main_frame";
        frontend = "tuboSoundcloud";
        unsupportedUrls = "bypass";
        redirectOnlyInIncognito = false;
      };
      bandcamp = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "tent";
        redirectOnlyInIncognito = false;
      };
      tekstowo = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "tekstoLibre";
        redirectOnlyInIncognito = false;
      };
      genius = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "dumb";
        instance = "public";
        redirectOnlyInIncognito = false;
      };
      medium = {
        enabled = false;
        frontend = "scribe";
        unsupportedUrls = "bypass";
        redirectOnlyInIncognito = false;
      };
      quora = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "quetre";
        instance = "public";
        redirectOnlyInIncognito = false;
      };
      github = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "gothub";
        redirectOnlyInIncognito = false;
      };
      gitlab = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "laboratory";
        redirectOnlyInIncognito = false;
      };
      stackOverflow = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "anonymousOverflow";
        instance = "public";
        redirectOnlyInIncognito = false;
      };
      reuters = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "neuters";
        redirectOnlyInIncognito = false;
      };
      snopes = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "suds";
        redirectOnlyInIncognito = false;
      };
      ifunny = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "unfunny";
        redirectOnlyInIncognito = false;
      };
      tenor = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "soprano";
        redirectOnlyInIncognito = false;
      };
      knowyourmeme = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "meme";
        redirectOnlyInIncognito = false;
      };
      urbanDictionary = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "ruralDictionary";
        redirectOnlyInIncognito = false;
      };
      goodreads = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "biblioReads";
        instance = "public";
        redirectOnlyInIncognito = false;
      };
      wolframAlpha = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "wolfreeAlpha";
        redirectOnlyInIncognito = false;
      };
      instructables = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "structables";
        redirectOnlyInIncognito = false;
      };
      wikipedia = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "wikiless";
        redirectOnlyInIncognito = false;
      };
      waybackMachine = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "waybackClassic";
        redirectOnlyInIncognito = false;
      };
      pastebin = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "pasted";
        instance = "public";
        redirectOnlyInIncognito = false;
      };
      search = {
        enabled = false;
        frontend = "searxng";
        unsupportedUrls = "bypass";
        redirectGoogle = false;
        instance = "public";
        redirectOnlyInIncognito = false;
      };
      translate = {
        enabled = false;
        frontend = "simplyTranslate";
        unsupportedUrls = "bypass";
        instance = "public";
        redirectOnlyInIncognito = false;
      };
      maps = {
        enabled = false;
        redirectType = "main_frame";
        frontend = "osm";
        unsupportedUrls = "bypass";
        redirectOnlyInIncognito = false;
      };
      meet = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "jitsi";
        redirectOnlyInIncognito = false;
      };
      sendFiles = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "send";
        redirectOnlyInIncognito = false;
      };
      textStorage = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "privateBin";
        redirectOnlyInIncognito = false;
      };
      office = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "cryptPad";
        redirectOnlyInIncognito = false;
      };
      ultimateGuitar = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "freetar";
        redirectOnlyInIncognito = false;
      };
      baiduTieba = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "ratAintTieba";
        redirectOnlyInIncognito = false;
      };
      threads = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "shoelace";
        redirectOnlyInIncognito = false;
      };
      deviantArt = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "skunkyArt";
        redirectOnlyInIncognito = false;
      };
      geeksForGeeks = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "nerdsForNerds";
        redirectOnlyInIncognito = false;
      };
      coub = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "koub";
        redirectOnlyInIncognito = false;
      };
      chefkoch = {
        enabled = false;
        unsupportedUrls = "bypass";
        frontend = "gocook";
        redirectOnlyInIncognito = false;
      };

      # ---- instance lists (defaults) ----
      invidious = [];
      materialious = ["https://app.materialio.us"];
      piped = ["https://pipedapi-libre.kavin.rocks"];
      pipedMaterial = ["https://piped-material.xn--17b.net"];
      poketube = ["https://poketube.fun"];
      cloudtube = ["https://tube.cadence.moe"];
      lightTube = ["https://tube.kuylar.dev"];
      tuboYoutube = ["https://tubo.media"];
      viewtube = ["https://viewtube.io"];
      ytify = ["https://ytify.pp.ua"];
      ytifyMusic = ["https://ytify.pp.ua"];
      hyperpipe = ["https://hyperpipe.surge.sh"];
      invidiousMusic = [];
      nitter = ["https://nitter.privacydev.net"];
      skyview = ["https://skyview.social"];
      skylib = ["https://skylib.coffee"];
      libreddit = [];
      teddit = [];
      eddrit = ["https://eddrit.com"];
      troddit = ["https://www.troddit.com"];
      priviblur = ["https://pb.bloat.cat"];
      safetwitch = ["https://safetwitch.drgns.space"];
      twineo = ["https://twineo.exozy.me"];
      proxiTok = ["https://proxitok.pabloferreiro.es"];
      offtiktok = ["https://www.offtiktok.com"];
      kittygram = ["https://kittygram.irelephant.net/"];
      proxigram = ["https://ig.opnxng.com"];
      libremdb = ["https://libremdb.iket.me"];
      mikuInvidious = [];
      pixivFe = ["https://pixiv.perennialte.ch"];
      liteXiv = ["https://litexiv.465321.best" "https://litexiv.bloat.cat"];
      vixipy = ["https://vx.maid.zone"];
      pixivViewer = ["https://pixiv.pictures"];
      breezeWiki = ["https://breezewiki.com"];
      phantom = ["https://phantom.kuuro.net"];
      rimgo = ["https://rimgo.vern.cc"];
      binternet = ["https://bn.bloat.cat"];
      painterest = ["https://pt.bloat.cat"];
      tuboSoundcloud = ["https://tubo.media"];
      soundcloak = ["https://soundcloak.fly.dev"];
      tent = ["https://tent.sny.sh"];
      tekstoLibre = ["https://davilarek.github.io/TekstoLibre"];
      dumb = ["https://dm.vern.cc"];
      intellectual = ["https://intellectual.insprill.net"];
      scribe = ["https://scribe.rip"];
      libMedium = ["https://md.vern.cc"];
      small = ["https://small.bloat.cat"];
      freedium = ["https://freedium.cfd"];
      quetre = ["https://quetre.iket.me"];
      gothub = [];
      laboratory = ["https://lab.vern.cc"];
      anonymousOverflow = ["https://code.whatever.social"];
      neuters = ["https://neuters.de"];
      suds = ["https://sd.vern.cc"];
      unfunny = ["https://uf.vern.cc"];
      soprano = ["https://sp.vern.cc"];
      meme = ["https://mm.vern.cc"];
      ruralDictionary = ["https://rd.vern.cc"];
      biblioReads = [];
      wolfreeAlpha = [];
      structables = ["https://structables.private.coffee"];
      destructables = ["https://ds.vern.cc"];
      indestructables = ["https://indestructables.private.coffee"];
      wikiless = [];
      wikimore = ["https://wikimore.private.coffee"];
      waybackClassic = ["https://wayback-classic.net"];
      pasted = ["https://pasted.drakeerv.com"];
      searxng = ["https://nyc1.sx.ggtyler.dev"];
      searx = [];
      whoogle = [];
      librey = [];
      "4get" = ["https://4get.ca"];
      websurfx = ["https://alamin655-spacex.hf.space"];
      simplyTranslate = ["https://simplytranslate.org"];
      mozhi = ["https://mozhi.aryak.me"];
      libreTranslate = ["https://libretranslate.com"];
      translite = ["https://tl.bloat.cat"];
      osm = ["https://www.openstreetmap.org"];
      jitsi = [];
      send = [];
      privateBin = [];
      pasty = ["https://pasty.lus.pm"];
      cryptPad = ["https://cryptpad.org"];
      freetar = ["https://freetar.de"];
      ratAintTieba = ["https://rat.fis.land"];
      shoelace = ["https://shoelace.mint.lgbt"];
      skunkyArt = ["https://skunky.bloat.cat"];
      nerdsForNerds = ["https://nn.vern.cc"];
      ducksForDucks = ["https://ducksforducks.private.coffee"];
      koub = ["https://koub.clovius.club"];
      gocook = ["https://cook.adminforge.de"];
      ultimateTab = ["https://ultimate-tab.com"];

      # ---- global settings ----
      exceptions = {
        url = [];
        regex = [];
      };
      theme = "detect";
      popupServices = ["youtube" "tiktok" "imgur" "reddit" "quora" "translate" "maps"];
      fetchInstances = "github";
      redirectOnlyInIncognito = false;
    };
  };

  settingsFile = pkgs.writeText "libredirect-storage.js" (builtins.toJSON settings);
in {
  programs.zen-browser.profiles.${profileName}.extensions.packages = [pkgs.firefoxAddons.libredirect];

  # Seeds storage.js on first install; does not overwrite if already present
  # so runtime changes in the extension UI survive home-manager switch.
  home.activation.libredirectStorage = lib.hm.dag.entryAfter ["writeBoundary"] ''
    _storage_dir="$HOME/.config/zen/${profileName}/browser-extension-data/7esoorv3@alefvanoon.anonaddy.me"
    _storage_file="$_storage_dir/storage.js"
    if [ ! -f "$_storage_file" ]; then
      mkdir -p "$_storage_dir"
      cp ${settingsFile} "$_storage_file"
      chmod 644 "$_storage_file"
    fi
  '';
}
