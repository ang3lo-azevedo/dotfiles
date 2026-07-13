{
  pkgs,
  inputs,
  ...
}: let
  appleColorEmojiPackage = inputs.berberman.packages.${pkgs.stdenv.hostPlatform.system}.apple-emoji;
in {
  stylix = {
    enable = true;

    # Activate dark mode
    polarity = "dark";

    targets = {
      zen-browser.colors.enable = true;
      vscode.colors.enable = false;
      nixcord.colors.enable = false;

      gtk.extraCss = ''
        .hotkey-overlay {
          font-family: "JetBrainsMono Nerd Font";
          font-size: 14px;
          background-color: #000000;
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.1);
          border-radius: 8px;
          box-shadow: 0 4px 16px rgba(0, 0, 0, 0.4);
        }

        .hotkey-overlay row {
          border-radius: 6px;
          padding: 2px 8px;
        }

        .hotkey-overlay row:hover {
          background-color: #2a2a2a;
        }
      '';
    };

    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };

      emoji = {
        #package = inputs.apple-emoji.packages.${pkgs.stdenv.hostPlatform.system}.default;
        package = appleColorEmojiPackage;
        name = "Apple Color Emoji";
      };
    };

    # Custom base16 color scheme
    base16Scheme = {
      base00 = "000000"; # Default Background
      base01 = "000000"; # Lighter Background (Used for status bars, line number and folding marks)
      base02 = "111111"; # Selection Background
      base03 = "444444"; # Comments, Invisibles, Line Highlighting
      base04 = "999999"; # Dark Foreground (Used for status bars)
      base05 = "ffffff"; # Default Foreground, Caret, Delimiters, Operators
      base06 = "ededed"; # Light Foreground (Not often used)
      base07 = "ffffff"; # Light Background (Not often used)
      base08 = "f56464"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      base09 = "f99902"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
      base0A = "f99902"; # Classes, Markup Bold, Search Text Background
      base0B = "58c760"; # Strings, Inherited Class, Markup Code, Diff Inserted
      base0C = "14cbb7"; # Support, Regular Expressions, Escape Characters, Markup Quotes
      base0D = "888888"; # Functions, Methods, Attribute IDs, Headings
      base0E = "b675f1"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
      base0F = "b675f1"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    };
  };
}
