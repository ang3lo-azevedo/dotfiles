{ pkgs, inputs, ... }:
{
  stylix = {
    enable = true;

    # Activate dark mode
    polarity = "dark";

    targets.zen-browser.colors.enable = false;
    targets.vscode.colors.enable = false;
    targets.nixcord.colors.enable = false;

    fonts = {
      serif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };

      emoji = {
        package = inputs.apple-emoji.packages.${pkgs.stdenv.hostPlatform.system}.default;
        name = "Apple Color Emoji";
      };
    };

    # Custom base16 color scheme
    base16Scheme = {
      base00 = "000000"; # Default Background
      base01 = "111111"; # Lighter Background (Used for status bars, line number and folding marks)
      base02 = "2a2a2a"; # Selection Background
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
      base0D = "62a6ff"; # Functions, Methods, Attribute IDs, Headings
      base0E = "b675f1"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
      base0F = "b675f1"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    };
  };
}
